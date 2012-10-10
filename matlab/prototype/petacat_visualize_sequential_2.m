




clear all; close all; clc;





%% parameters and prep work

    % load images
        fnames = {'dogwalking3.jpg'};
        
    % build salience model
        hmax_model = hmax_model_initialize();
        
    % set crop parameters
        roi_method = 'salience'; % 'ncuts' or 'salience'
        % roi_method = 'ncuts';
        k = 5;  % number of centroids to model when using GMM
                % or number of segments for NCUTS
        
    % define class options
        class_options = {'dogs', 'pedestrians', 'leashes'};
        
    % build glimpse
        % not actually a thing

    % define input keys

        input_key = 0;      

        key_mark = 1;       % left click
        key_delete = 8;     % 'delete'
        key_prev = 28;      % <-
        key_next = 29;      % ->
        key_reset = 114;    % 'r'
        key_end = 27;       % 'esc'
        


        
        
%% run salience / ncuts to get bounding boxes

    image = imread( fnames{1} );
    
    if strcmp( roi_method, 'salience' );
        hmax_data  = hmax_fn2c1( hmax_model, fnames );
        salience_map = hmax_data.salience_r;
        [mu,Sigma] = empdist_to_gmm( salience_map, k );
        coords = gmm_box_coords(mu,Sigma,2);
        box_coords = coords;
        box_source_map = hmax_data.salience_r;
        % centroids  = mu;
    elseif strcmp( roi_method, 'ncuts' )
        [box_coords,segments] = mq_ncuts_adjusted( imresize(rgb2gray(image),.5), k, false );
        box_coords = round(2 * box_coords);
        % the first row is for "class 0", which should be discarded
        box_coords = box_coords(2:end,:);
        segments = mat2gray( imresize( segments, [size(image,1), size(image,2)], 'nearest') );
        box_source_map = segments;
        salience_map = segments;
    else
        error(' ','unknown cropping method specified');
    end
    
    
    
    
    
%% use salience to classify crops

    % get crops, just for one image for now

      % from the image and box coords, pull out some crops
            k = size(box_coords,1);
            crops = cell(1,k);
            for ci = 1:k
                r0 = round( box_coords(ci,2) );
                rf = round( box_coords(ci,4) );
                c0 = round( box_coords(ci,1) );
                cf = round( box_coords(ci,3) );

                r0 = max(r0,1);
                rf = min(rf,size(image,1));
                c0 = max(c0,1);
                cf = min(cf,size(image,2));

                crops{ci} = image( r0:rf, c0:cf );
            end



    % guess a class for each crop
    % apply glimpse

        class_guesses = class_options( randi(3,1,k) );
        dvars = zeros(1,k);
        for ci = 1:k
            dvars(ci) = apply_glimpse_model( class_guesses{ci}, crops{ci} );
            fprintf('.')
        end
        fprintf('\n glimpse done \n');

        

        
        
%% run visualizer

    roi_map = salience_map;
    model_names = class_guesses;
    boxes_roi = box_coords;
    pv = petacat_visualizer(image,roi_map,boxes_roi,model_names,dvars);
    pv.update_from_input();
    
    
    
 









