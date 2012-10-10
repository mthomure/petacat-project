function [max_r, max_c] = imshow_max( x, arg )

    % [max_r, max_c] = imshow_max( x, arg );
    
    
    
    if nargin < 1
        x = .5 * rand(50,50);
        x(10,20) = 1;
        x(10,30) = 1;
    end
    
    [~,max_r,max_c] = max2(x);

    if exist('arg','var'); imshow(x,arg);
    else imshow(x); end
    hold on
    plot(max_c,max_r,'or');
    hold off
    
end




function [val,i,j] = max2(x)

    val = max(x(:));

    [i,j] = find( reshape( ...
                eq( x(:), val ), ...
                size(x,1),...
                size(x,2)));
            
end
