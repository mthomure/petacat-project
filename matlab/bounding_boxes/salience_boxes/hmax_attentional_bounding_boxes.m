 


function [centroids,boxes] = hmax_attentional_bounding_boxes( fnames, k, show_figs )

    % [centroids,boxes] = hmax_attentional_bounding_boxes( fnames, k, show_figs );
    %
    % [centroids,boxes] = hmax_attentional_bounding_boxes( [], 5, true );
    %
    %
    %
    % fnames should be a cell array of filenames
    % k is the number of gmm clusters to model
    %
    % centroids will be a cell array of cluster centers
    % boxes     will be a cell array of box coords
    % 
    % ie, centroids{i} is a matrix of centroids for the image at fnames{i}
    % boxes{i} is a matrix of box bounds for centroids{i}

    
    
    if ~exist('fnames','var') || isempty( fnames )
        fnames{1} = 'fruit.jpg';
        fnames{2} = 'dogwalking3.jpg';
        fnames{3} = 'lincoln2.jpg';
    end
    
    if ~exist('k','var') || isempty( k )
        k = 5;
    end
    
    if ~exist('show_figs','var') || isempty(show_figs)
        show_figs = false;
    end
    
    if ischar(fnames)
        % if a single fname is passed in as a string, just make it a
        % singleton cell array;
        fnames = {fnames};
    end

    
    
    % process inputs

        % build model with default parameters
            model = hmax_model_initialize();

        % load and process images through C1
                % takes an hmax model specification (initialized above)
                % and a list of filenames in a cell array
            data = hmax_fn2c1( model, fnames );
                % 'fname is the name of the image source for this data entry'
                % 'im is the image at the fname location'
                % 's1 has s1 feature maps'
                % 'c1a has receptive fields related to the size of the s1 filters'
                % 'c1b has receptive fields related to the size of the c2 receptive fields (kinda busted right now)
                % 'c1a_r resizes c1 maps to match up with each other, allowing for easy multiscale features'
                % 'c1max takes the max value over an entire feature map, so is a num_scales x num_features matrix'

        centroids = cell(length(fnames),1);
        boxes     = cell(length(fnames),1);
        for imi = 1:length(fnames)

            cur_image = data(imi).im;
            x = data(imi).c1a_r;  
            
            % use itti's per-feature map normalization
            %   probably useful for salience, 
            %   not so much for classification
                for i = 1:size(x,3)
                    x(:,:,i) = mat2gray(x(:,:,i));
                    x(:,:,i) = (1-mean(mean(x(:,:,i)))).^2 * x(:,:,i);
                end

            % combine maps, smooth?, and fit GMM
                x = sum( x, 3 );
                %m = 5;
                %h = blackman(m)*blackman(m)';
                %h = h / sum(h(:));
                %x = filtern( h, x );
                [mu,Sigma] = empdist_to_gmm( x, k );

            % gather box coordinates
                coords = gmm_box_coords(mu,Sigma,2);

            % and rescale for the original image size
                centroids{imi} = round( mu * size(cur_image,2)/size(x,2) );
                boxes{imi}     = round( coords * size(cur_image,2)/size(x,2) );

            if show_figs
                
                figure;

                    subplot(2,1,1);
                    imshow( sum(x,3), [] )
                    hold on
                    plot(mu(:,2),mu(:,1),'or');
                    draw_box(coords);
                    hold off;

                    subplot(2,1,2);
                    imshow(cur_image);
                    hold on
                    plot(centroids{imi}(:,2),centroids{imi}(:,1),'or');
                    draw_box(boxes{imi});
                    hold off;
                    
            end

        end
        
        
        
        
end


            

            

