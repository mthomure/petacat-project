
classdef petacat_prototype_2 < handle
        
        
        
        properties
            
            % source information
                fn_image
                fn_label

            % image and ground truth
                image           = [];
                gt_boxes        = [];
                gt_labels       = [];
                gt_class_inds   = [];

            % classification options
                class_options = {'dogs','pedestrians','leashes'};
                hmax_model = []; % used for generating salience map
                k = []; % number of ROI boxes to use
                
            % region of interest boxes
                roi_method      = []; % salience, segmentation, random
                roi_map         = []; % map used to generat boxes
                roi_boxes       = [];
                
                roi_dvars       = []; % may be incomplete
                roi_box_polled  = []; % boolean indicator of whether the 
                                      % box has been evaluated with a 
                                      % particular model yet 

            % results
                intersection = [];  % between roi boxes and gt boxes
                results = [];       % per box, assign TP, FP, TN, FN
                
                res_tp = [];
                res_fp = [];
                res_tn = [];
                res_fn = [];
                
        end
                
                
        
        methods
 

            function pc = petacat_prototype_2(image,label,k_in)
                
                if ~exist('image','var') || isempty(image)
                    display('using default image');
                    image = '/Users/Max/Desktop/Petacat work/images/dog-walking-from-web/dog-walking-from-web1.jpg';
                end
                
                if ischar(image)
                    pc.fn_image = image;
                    pc.image = double(imread(image))/255;
                    
                    if exist('label','var')
                        pc.fn_label = label;
                    else
                        fn_label_possible = ...
                            [pc.fn_image(1:end-4) '.labl'];
                        if exist(fn_label_possible,'file')
                            pc.fn_label = fn_label_possible;
                        end
                        clear fn_label_possible;
                    end
                    
                else
                    pc.image = image;
                end
                
                if ~exist('k_in','var') || isempty(k_in)
                    pc.k = 5;
                else
                    pc.k = k_in;
                end
                
                pc.roi_boxes       = zeros(pc.k,4);
                pc.roi_dvars       = zeros(pc.k,length(pc.class_options)); % may be incomplete
                pc.roi_box_polled  = false(pc.k,length(pc.class_options)); % 

                
            end
            
            function load_gt(pc)
                
                fid = fopen( pc.fn_label );
                specification_string = fgetl(fid);
                spec = split( specification_string, '|' );
                fclose(fid);

                num_boxes = str2num( spec{3} );

                % loop through for box specifications
                    si = 4; % cur spec index, modify if the specification format changes
                    for bi = 1:num_boxes
                        x = str2num(   spec{si} );
                        y = str2num( spec{si+1} );
                        w = str2num( spec{si+2} );
                        h = str2num( spec{si+3} );
                        pc.gt_boxes(bi,1:4) = [x y w h];
                        si = si + 4; % iterate for the next box
                    end

                % loop through for get_labels
                % check first few characters for class_ind
                    pc.gt_class_inds = zeros(1,num_boxes);
                    for bi = 1:num_boxes
                        pc.gt_labels{bi} = spec{si};
                        for ci = 1:length(pc.class_options)
                            if pc.gt_labels{bi}(1:3) == pc.class_options{ci}(1:3)
                                pc.gt_class_inds(bi) = ci;
                            end
                        end
                        si = si+1;
                    end
                
                % remove any labels that we don't understand
                    unknown_class_inds = eq(pc.gt_class_inds,0);
                    pc.gt_boxes(unknown_class_inds,:) = [];
                    pc.gt_labels(unknown_class_inds) = [];
                    pc.gt_class_inds(unknown_class_inds) = [];
                
            end
            
            function resize(pc,max_dim)
               
                scale = max_dim / max(size(pc.image,1),size(pc.image,2));
                pc.image = imresize(pc.image,scale);
                pc.gt_boxes = scale * pc.gt_boxes;
                
                if ~isempty(pc.roi_boxes)
                    pc.roi_boxes = scale * pc.roi_boxes;
                end
                
            end
            
            function generate_boxes(pc,method)
                
                if ~exist('method','var') || isempty(method)
                    method = 'random';
                end
                pc.roi_method = method;
               
                switch method
                
                    case 'salience'

                        pc.hmax_model = hmaxq_model_initialize();
                        pc.roi_map = hmaxq_salience( pc.hmax_model, pc.image );
                        [mu,Sigma] = empdist_to_gmm( pc.roi_map, pc.k );
                        coords = gmm_box_coords(mu,Sigma,2);
                        
                        x = coords(:,1);
                        y = coords(:,2);
                        w = coords(:,3) - x + 1;
                        h = coords(:,4) - y + 1;
                        pc.roi_boxes = [x y w h];

                    case 'segmentation'
                  
                        % segment at half resolution, then rescale to full
                        % sized image
                        [segmentation_bounds,segmentation] = mq_ncuts_adjusted( imresize(pc.image,.5), pc.k, false );
                        segmentation_bounds = round(2 * segmentation_bounds);
                        
                        % the first row is for "class 0", 
                        % class zero is used to block the frayed edges of segments
                        % it should be discarded
                        segmentation_bounds = segmentation_bounds(2:end,:);
                        segmentation = mat2gray( imresize( segmentation, [size(pc.image,1), size(pc.image,2)], 'nearest') );

                        pc.roi_map   = segmentation;
                        x = segmentation_bounds(:,1);
                        y = segmentation_bounds(:,2);
                        w = segmentation_bounds(:,3) - x + 1;
                        h = segmentation_bounds(:,4) - y + 1;
                        pc.roi_boxes = [x y w h];
                       
                    case 'random'
                    
                        pc.roi_map   = .5 * ones(size(pc.image,1),size(pc.image,2));

                        if exist('ratios.mat','file')
                            r = load('ratios.mat');
                        else
                            r = get_ratio_data;
                            save('ratios.mat','-struct','r');
                        end
                        
                        aspect_ratios  = [];
                        aspect_ratios = [aspect_ratios r.aspect_dog];
                        aspect_ratios = [aspect_ratios r.aspect_human];
                        aspect_ratios = [aspect_ratios r.aspect_leash];
                        
                        area_ratios  = [];
                        area_ratios = [area_ratios r.area_dog];
                        area_ratios = [area_ratios r.area_human];
                        area_ratios = [area_ratios r.area_leash];
                        
                        for i = 1:pc.k
                            
                            rand_ind = randi( length( aspect_ratios ) );
                            aspect = aspect_ratios( rand_ind );
                            area = area_ratios( rand_ind );
                            box = random_box( area, aspect, size(pc.image,2), size(pc.image,1) );
                            pc.roi_boxes(i,:) = box;
                        end

                end
                
            end
            
            function draw(pc)
                
                figure
                
                    subplot(1,2,1)
                        hold on
                        imshow(pc.image)
                        for bi = 1:size(pc.gt_boxes,1)
                            rect_draw_position(pc.gt_boxes(bi,:),'g');
                            text(...
                                pc.gt_boxes(bi,1), pc.gt_boxes(bi,2),...
                                sprintf('%s', ...
                                    pc.class_options{pc.gt_class_inds(bi)}),...
                                'EdgeColor',[0 0 1],...
                                'BackgroundColor',[.5 .5 .5],...
                                'Color',[0 0 0] );
                        end
                        hold off;
                        

                    subplot(1,2,2)
                        hold on;
                        imshow(pc.roi_map,[])
                        for bi = 1:size(pc.roi_boxes,1)
                            rect_draw_position(pc.roi_boxes(bi,:),'b');
                            
                            polled_list = pc.roi_box_polled(bi,:);
                            cur_dvar  = max(pc.roi_dvars(bi,polled_list));
                            cur_class_ind = find(eq(cur_dvar,pc.roi_dvars(bi,:)),1);
                            cur_class = pc.class_options{cur_class_ind};
                            
                            text(...
                                pc.roi_boxes(bi,1), pc.roi_boxes(bi,2),...
                                sprintf('%s %.3f', ...
                                    cur_class, cur_dvar),...
                                'EdgeColor',[0 0 1],...
                                'BackgroundColor',[.5 .5 .5],...
                                'Color',[0 0 0] );
                        end
                        hold off;
                        
            end
            
            function classify(pc,class_ind)
                
                % if no class to check is specified, 
                % or if the class specified is 0,
                % then use a randomly selected class that has not already
                % been polled for that box
                
                if all(pc.roi_box_polled(:))
                    % nothing left to classify, get out
                    return
                end
                
                if ~exist('class_ind','var') || isempty(class_ind)
                    class_ind = 0;
                end
                
                boxes = pc.roi_boxes;
                
                for bi = 1:size(boxes,1)
                    
                    % select a class
                        if class_ind ~= 0
                            cur_class = class_ind;
                        else
                            unchecked_classes = find( 1 - pc.roi_box_polled(bi,:) );
                            cur_class = unchecked_classes( randi( length(unchecked_classes)));
                        end
                    
                    % get a crop
                    
                        r0 = max(1,boxes(bi,2));
                        rf = min(r0 + boxes(bi,4) - 1, size(pc.image,1));
                        c0 = max(1,boxes(bi,1));
                        cf = min(c0 + boxes(bi,3) - 1, size(pc.image,2));

                        r0 = round(r0);
                        rf = round(rf);
                        c0 = round(c0);
                        cf = round(cf);

                        cur_crop = pc.image(r0:rf,c0:cf,:);
                        
                        if size(cur_crop,3) > 1
                            cur_crop = rgb2gray(cur_crop);
                        end
                        

                    % classify and record
                        pc.roi_dvars(bi,cur_class) = ...
                            apply_glimpse_model( ...
                                pc.class_options{cur_class}, ...
                                cur_crop);
                        
                        pc.roi_box_polled(bi,cur_class) = true;
                        
                    fprintf('.');
                        
                end
                fprintf('\n');
                
            end

            function calculate_intersection(pc)
                
                pc.intersection = zeros(pc.k,size(pc.gt_boxes,1));
                
                for bi_roi = 1:size(pc.roi_boxes,1)
                for bi_gt = 1:size(pc.gt_boxes,1)
                    
                    box1 = pc.gt_boxes(bi_gt,:);
                    box2 = pc.roi_boxes(bi_roi,:);
                    
                    pc.intersection(bi_roi,bi_gt) = rect_intersection_ratio( box1, box2 );
                    
                end
                end
                
            end
            
            function gather_results(pc)
                
                pc.res_tp = zeros(size(pc.roi_boxes,1),size(pc.gt_boxes,1));
                pc.res_fp = zeros(size(pc.roi_boxes,1),size(pc.gt_boxes,1));
                pc.res_tn = zeros(size(pc.roi_boxes,1),size(pc.gt_boxes,1));
                pc.res_fn = zeros(size(pc.roi_boxes,1),size(pc.gt_boxes,1));
                
                for bi = 1:size(pc.roi_boxes,1)
                for gi = 1:size(pc.gt_boxes,1)
                   
                    overlap = pc.intersection(bi,gi);
                    cc_polled = pc.roi_box_polled(bi,pc.gt_class_inds(gi));
                    dvar = pc.roi_dvars(bi, logical(pc.roi_box_polled(bi,:)) );
                    
                    [tp(bi,gi),fp(bi,gi),tn(bi,gi),fn(bi,gi)] = check_hit( overlap, cc_polled, dvar );
                    
                end
                end
                
                pc.res_tp = tp;
                pc.res_fp = fp;
                pc.res_tn = tn;
                pc.res_fn = fn;
                
                % reconcile results
                    for bi = 1:size(pc.roi_boxes,1)
                        if any(pc.res_tp(bi,:))
                            % TP
                            final_result = 1;
                        elseif any(pc.res_fp(bi,:))
                            % FP
                            final_result = 2;
                        elseif any(pc.res_fn(bi,:))
                            % FN
                            final_result = 3;
                        elseif any(pc.res_tn(bi,:))
                            % TN
                            final_result = 4;
                        end
                        
                        pc.results(bi) = final_result;
                    
                    end
                   
            end
            
            
        end
        
        
end
 


% calling scripts
 
function pc = peta_caller(fname,method)

    if ~exist('fname','var') || isempty(fname)
        fname = [];
    end
    if ~exist('method','var') || isempty(method)
        method = 'random';
    end

    pc = petacat_prototype_2(fname);
    pc.load_gt;

    max_dim = 500;
    pc.resize(max_dim);
    pc.generate_boxes(method);
    pc.classify;

    pc.calculate_intersection;
    pc.gather_results;

end

function results = iterated_caller()

    fnames = {...
        '/Users/Max/Desktop/Petacat work/images/dog-walking-from-web/dog-walking-from-web1.jpg',...
        '/Users/Max/Desktop/Petacat work/images/dog-walking-from-web/dog-walking-from-web2.jpg',...
        '/Users/Max/Desktop/Petacat work/images/dog-walking-from-web/dog-walking-from-web3.jpg',...
        '/Users/Max/Desktop/Petacat work/images/dog-walking-from-web/dog-walking-from-web4.jpg',...
        '/Users/Max/Desktop/Petacat work/images/dog-walking-from-web/dog-walking-from-web5.jpg'...
        };

    method_options = {'random','salience','segmentation'};
    
    results = cell(3,1);
    for mi = 1:length(method_options)
    for fi = 1:length(fnames)
        
        tic;
        
        fname = fnames{fi};
        method = method_options{mi};
        
        pc = peta_caller(fname,method);
        results{mi} = [results{mi}; pc.results];
        save(sprintf('pc_fi%d_mi%s',fi,method),'pc');
        clear pc;
        
        fprintf('%.3f, %s, %s\n',toc,method,fname);
        
    end
    end
    
end



% required helper functions

function [] = rect_draw_position( x, arg )

    % rect_draw_position(x,'arg')
    %
    % x,y,w,h
    % or 
    % col,row,cols,rows

    for i = 1:size(x,1)
        
        rs = [x(i,1) x(i,1) x(i,1)+x(i,3) x(i,1)+x(i,3) x(i,1)];
        cs = [x(i,2) x(i,2)+x(i,4) x(i,2)+x(i,4) x(i,2) x(i,2)];
        
        if ~exist('arg','var')
            plot(rs,cs);
        else
            plot(rs, cs, arg);
        end
        
    end
   
end

function result = split( s, d )

% [result] = split( s, d );
%
% s is a string
% d is a delimiter (or list of delimiters)
%   if not specified, any white space is used
%
% result is a cell array of the parsed strings
%
% example:
%   result = split( 'hello|stupid world', {'|',' '} );


    if ~exist('d','var') || isempty( d )
       
        % use the default delimiter behavior (any whitespace)
        
        % grab the initial token
            [token,remainder] = strtok(s);
            result{1} = token;

        % loop while there are tokens left to grab
            i = 2;
            while(remainder)
                [token,remainder] = strtok(remainder);
                result{i} = token;
                i = i + 1;
            end
        
        
    else
        
         % use all of the delimiters in d
         
        [token,remainder] = strtok(s,d);
        result{1} = token;

        i = 2;
        while(remainder)
            [token,remainder] = strtok(remainder,d);
            result{i} = token;
            i = i + 1;
        end
        
    end
    
end

function b = random_box( area_r, aspect_r, im_w, im_h )

%     area_r = .2;
%     aspect_r = 2;
%     im_w = 100;
%     im_h = 100;

    b_h = aspect_r;
    b_w = 1;
    b_a = b_h * b_w;
    scale = sqrt( (area_r * im_w * im_h ) / b_a );
    
    b_h = round(b_h * scale);
    b_w = round(b_w * scale);
    
    if b_h > im_h, b_h = im_h; end
    if b_w > im_w, b_w = im_w; end
    
    x = randi( im_w - b_w + 1 );
    y = randi( im_h - b_h + 1 );
    
    b = [x y b_w b_h];
    
end

function [tp,fp,tn,fn] = check_hit( overlap, cc_polled, dvar )

    tp = false;
    fp = false;
    tn = false;
    fn = false;
    
    
    if overlap > .5
        
        if cc_polled
            if dvar > 0
                % a good box was selected
                % the correct class was tested
                % the decision was positive
                tp = true;
            else % dvar < 0
                % a good box was selected
                % the correct class was tested
                % the decision was negative
                fn = true;
            end
        else % not cc_polled
            if dvar > 0
                % a good box was selected
                % but the correct class was not polled
                % the classifier thought the box was this other class
                fp = true;
            else % dvar < 0
                % a good box was selected
                % but the correct class was not polled
                % the classifier rejected the proposed class
                tn = true;
            end
        end
        
    else % overlap < .5
        
        if dvar > 0
            % the box was not consistent with any of the ground truth
            % so there is no correct class to consider
            % but the classifier says it saw something anyway
            fp = true;
        else % dvar < 0
            % the box was not consistent with any of the ground truth
            % so there is no correct class to consider
            % and the classifier did not recognize anything
            tn = true;
        end
        
    end
     
    
end



