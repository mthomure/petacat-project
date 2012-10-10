function temp = imshow_nrgb( input, arg )


    % hsv has a hue, saturation, and value layer
    %
    %   hue is a value from 0 to 1. each layer of input gets its own.
    %   saturation is always set to 1.
    %   value is is the intensity of the layer of input.


    if size(input,3) == 1
        
        temp = input;
    
    else

        n = size(input,3);
        
        hues = linspace(0,1,n+1);
        hues(end) = [];

        [r,c] = size(input(:,:,1));
        temp = zeros(r,c,3);
        for i = 1:n

            hsv(:,:,1) = hues(i) * ones(r,c);
            hsv(:,:,2) = ones(r,c);
            hsv(:,:,3) = input(:,:,i);
            temp = temp + hsv2rgb( hsv );

        end
        
    end

    
    
    if exist('arg','var'); 
        if isempty(arg)
            imshow( mat2gray(temp) );
        else
            imshow( (temp - arg(1))/(arg(2)-arg(1)) );
        end
    else
        imshow( temp );
    end
    
    
    
end
    