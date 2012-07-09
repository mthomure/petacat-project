


function data = hmax_fn2c1( model, fnames )



    if ~exist('model','var') || isempty(model)
        model = hmax_model_initialize();
    end
    
    if ~exist('fnames','var') || isempty(fnames)
        % as test images, we're just using a few views of two objects from
        % the ALOI set. object 1 is the teddy bear, object 9 is the shoe.
        fnames{1} = '/Users/Max/Documents/MATLAB/data/ALOI1000/1/1_r0.png';
        fnames{2} = '/Users/Max/Documents/MATLAB/data/ALOI1000/1/1_r45.png';
        fnames{3} = '/Users/Max/Documents/MATLAB/data/ALOI1000/1/1_r90.png';
        fnames{4} = '/Users/Max/Documents/MATLAB/data/ALOI1000/9/9_r0.png';
        fnames{5} = '/Users/Max/Documents/MATLAB/data/ALOI1000/9/9_r45.png';
        fnames{6} = '/Users/Max/Documents/MATLAB/data/ALOI1000/9/9_r90.png';
    end
    
    if ischar(fnames)
        % if a filename string was passed in, just make it a singleton cell
        % array
        fnames = {fnames};
    end
    
    data = struct();
    data.about = { ...
        'fname is the name of the image source for this data entry';...
        'im is the image at the fname location';...
        's1 has s1 feature maps';...
        'c1a has receptive fields related to the size of the s1 filters';...
        'c1b has receptive fields related to the size of the c2 receptive fields';...
        'c1a_r resizes c1 maps to match up with each other, allowing for easy multiscale features';...
        'c1max takes the max value over an entire feature map, so is a num_scales x num_features matrix'};

    
    

    
    for fni = 1:length(fnames)
tic;
    
    % load and store the image
        data(fni).fname = fnames{fni};
        x = imread(fnames{fni});
        x = double(x)/255;
        
        data(fni).im = x; % save off the original image. 
                          % we'll keep using x through the processing, so
                          % this can be commented out if we don't want the
                          % 'data' struct to bloat during larger
                          % experiments.
        
        % resize the image so the max dimension is 'model.redim' (scale up or down)
        % if the model specification leaves this empty, this step is skipped
        if ~isempty(model.redim)
            x = imresize( x, (model.redim)/max(size(x,1),size(x,2)) );
        end
        
        data(fni).im_r = x; % save off the resized image as well.
                            
    % split into color bands
        if size(x,3) == 3
            x = rgb2ycbcr(x);
        else
            x(:,:,2:3) = zeros(size(x,1),size(x,2),2);
        end 

        
        
        for si = 1: length(model.scales);
            
            % we're looping through the scales specified in the model
            % x is scaled based on the scales list, allowing for processing
            % at different frequency bands. small scale values make the
            % image smaller, removing high frequency components.
            %
            % we do this rather than use gabors with lower frequency
            % sensitivities because the effective frequency sensitivities 
            % are equivalent, but the procesing is much cheaper. 

            cur_scale = model.scales(si);
            x_sc = imresize(x,cur_scale);
            num_features = 3 + size(model.h1e,3);

            % this is set up so that we apply processing to one layer, then
            % allocate the rest of the layers based on the output size of
            % the first. 
            %
            % note: consider center surround in addition to retinal?
            % or in place of? for the color opponency operation.
            %
            % color representation might need to be different depending on
            % the intended use. for an attentional application, contrast
            % between colors seems important (red/green), but 'phase' does
            % not (red/green vs green/red). for classification purposes,
            % the contrast seems less important than the absolute color
            % (red is important, rather than its relationship to green)
            %
            % currently this is set up from an 
           
                s1        = retinal( x_sc(:,:,1), model.ret_w );                            % intensity
                s1(:,:,2) = retinal( x_sc(:,:,2), model.ret_w );                            % blue/yellow
                s1(:,:,3) = retinal( x_sc(:,:,3), model.ret_w );                            % red/green
                s1(:,:,end+1:end+size(model.h1e,3)) = filtern( model.h1e, x_sc(:,:,1) );    % edge orientation

            % do one layer, then make room for the rest of c1 (a and b)
                c1a = local_extrema( s1(:,:,1), model.c1a_w, model.c1a_s );
                c1a(:,:,2:num_features) = zeros( size(c1a,1), size(c1a,2), num_features-1 );
                
                c1b = local_extrema( s1(:,:,1), model.c1b_w, model.c1b_s );
                c1b(:,:,2:num_features) = zeros( size(c1b,1), size(c1b,2), num_features-1 );

                for fi = 2:3
                    c1a(:,:,fi) = local_extrema( s1(:,:,fi), model.c1a_w, model.c1a_s );
                    c1b(:,:,fi) = local_extrema( s1(:,:,fi), model.c1b_w, model.c1b_s );
                end
                for fi = 4:num_features
                    c1a(:,:,fi) = local_max( abs(s1(:,:,fi)), model.c1a_w, model.c1a_s  );
                    c1b(:,:,fi) = local_max( abs(s1(:,:,fi)), model.c1b_w, model.c1b_s );
                end

            % store the computed outputs
                data(fni).s1{si}  = s1;
                data(fni).c1a{si} = c1a;
                data(fni).c1b{si} = c1b;

        end

        
        % resize the c1a activations for easier S2 feature construction
            c1a_r = data(fni).c1a{1};
            nr = size(data(fni).c1a{1},1);
            nc = size(data(fni).c1a{1},2);
            nf = size(data(fni).c1a{1},3);
            for si = 2:length(data(fni).c1a)
                c1a_r(:,:,end+1:end+nf) = imresize(data(fni).c1a{si},[nr,nc],'nearest');
            end
            data(fni).c1a_r = c1a_r;
        
        % get per feature-map max values
        %   the distribution of this value, over multiple views of the same
        %   object, is the basis for the directed search model employed by
        %   Itti's group. 
        % Modifying this model with 
        %   a different color representation, 
        %   a different perspective on scale bands (extract more, look at only a band of adjacent), and 
        %   a few higher level configurational features
        %   seems to improve it substantially.
            for fi = 1:length(data(fni).c1a)
                data(fni).c1max(fi,:) = squeeze(max(max(data(fni).c1a{fi},[],1),[],2));
            end

        
fprintf( fnames{fni} ); fprintf(' %f\n', toc );
    end
    
    
    
end







