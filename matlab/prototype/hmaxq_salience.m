


function salience_r = hmaxq_salience( model, image )

    % salience_r = hmaxq_salience( model, image );


    
    % load and store the image
        
        im_in = image;
    
        % resize the image so the max dimension is 'model.redim' (scale up or down)
        % if the model specification leaves this empty, this step is skipped
        if ~isempty(model.redim)
            image = imresize( image, (model.redim)/max(size(image,1),size(image,2)) );
        end
        
        im_r = image; % save off the resized input image as well.
        
        
    % split into color bands
        if size(image,3) == 3
            image = rgb2ycbcr(image);
        else
            image(:,:,2:3) = zeros(size(image,1),size(image,2),2);
        end 

        
        c1a = cell(1,length(model.scales));
        for si = 1: length(model.scales);
            
            % we're looping through the scales specified in the model
            % image is scaled based on the scales list, allowing for processing
            % at different frequency bands. small scale values make the
            % image smaller, removing high frequency components.
            %
            % we do this rather than use gabors with lower frequency
            % sensitivities because the effective frequency sensitivities 
            % are equivalent, but the procesing is much cheaper. 

            cur_scale = model.scales(si);
            x_sc = imresize(image,cur_scale);
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
                
                % intensity
                    c1a_temp = local_extrema( s1(:,:,1), model.c1a_w, model.c1a_s );
                    c1a_temp(:,:,2:num_features) = zeros( size(c1a_temp,1), size(c1a_temp,2), num_features-1 );

                % color
                    for fi = 2:3
                        c1a_temp(:,:,fi) = local_extrema( s1(:,:,fi), model.c1a_w, model.c1a_s );
                    end
                    
                % orientation
                    for fi = 4:num_features
                        c1a_temp(:,:,fi) = local_max( abs(s1(:,:,fi)), model.c1a_w, model.c1a_s  );
                    end

                    
            % store the computed outputs
                c1a{si} = c1a_temp;
                    

        end

        
        % resize the c1a activations for easier S2 feature construction
            c1a_r = c1a{1};
            nr = size(c1a{1},1);
            nc = size(c1a{1},2);
            nf = size(c1a{1},3);
            for si = 2:length(c1a)
                c1a_r(:,:,end+1:end+nf) = imresize(c1a{si},[nr,nc],'nearest');
            end
            
        % get per feature-map max values
        %   the distribution of this value, over multiple views of the same
        %   object, is the basis for the directed search model employed by
        %   Itti's group. 
        % Modifying this model with 
        %   a different color representation, 
        %   a different perspective on scale bands (extract more, look at only a band of adjacent), and 
        %   a few higher level configurational features
        %   seems to improve it substantially.
            c1max = squeeze( max( max( c1a_r ) ) );
            
        % compute per image salience, based on feature integration theory
        % of attention
            salience_stack = c1a_r;
            for i = size(c1a_r,3)
                salience_stack(:,:,i) = mat2gray(salience_stack(:,:,i));
                salience_stack(:,:,i) = (1-mean(mean(salience_stack(:,:,i)))).^2 * salience_stack(:,:,i);
            end
            salience = sum( salience_stack, 3 );
            salience_r = ...
                imresize( ...
                    salience, ...
                    [size(im_in,1) size(im_in,2)], ...
                    'nearest');

     
    
end







