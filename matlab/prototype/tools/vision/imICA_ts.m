% ICA test script



    clear all; close all; clc;
    
    
    
    % get a data source

        use_digits = false;

        if use_digits

            load optdigits
            data = input_data';

        else % use an image

            im = double( imread('lincoln.jpg')) / 255;
            if size(im,3) > 1, im = rgb2gray(im); end
            im = 2*im - 1;
            im = retinal(im);
            data = chipper(im,8,1)';

        end

        
    
    % estimate ICs

        N = 16;
        ICs = imICA( data, N );

        
        
    % show result

        figure
        for i = 1:size(ICs,2)

            subplot(4,8,i)
            imshow( reshape( ICs(:,i), 8,8 ), [] );

        end

    
    
    
    