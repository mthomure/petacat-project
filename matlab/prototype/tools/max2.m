function [val,i,j] = max2(x)

    val = max(x(:));

    [i,j] = find( reshape( ...
                eq( x(:), val ), ...
                size(x,1),...
                size(x,2)));
            
end