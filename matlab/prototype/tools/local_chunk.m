function [z,rcs,ccs] = local_chunk(x,d,s)

% [y,rcs,ccs] = local_chunk(x,d,s);
%   x is the input map. if there are multiple layers, all layers will be pooled over for a given spatial location
%   d is the diameter over which to take the max (diameter)
%   s is the number of pixels between sampling centers (step size)
%
%   if d is specified and s is not, s will default such that all pixels are
%   included in at least one neighborhood, and the overlap between circular
%   neighborhoods is minimized
%
%   y is a large cell array of local sections
%   rcs are the row coordinates of the centers with respect to x
%   ccs are the column coordinates of the centers with respect to x
%








% set parameters

    if ~exist('x','var') || isempty(x)
        x = double(imread('cameraman.tif'))/255;
        display('local_max in demo mode'); 
    end

    if ~exist('d','var') || isempty(d); d = round(size(x,1)/20); end
    if ~exist('s','var') || isempty(s); s = d/sqrt(2); end
   

  
% move x above zero so our mask works properly

    min_val = min(x(:));
    x = x - min_val;
    
    
    
% allocate for output

    y = zeros( round(size(x,1)/s), round(size(x,2)/s) );
    
    rcs = round( linspace( s/2, size(x,1)-s/2, size(y,1) ) );
    r0s = round( rcs - d/2 );
    rfs = r0s + d - 1;
    
    ccs = round( linspace( s/2, size(x,2)-s/2, size(y,2) ) );
    c0s = round( ccs - d/2 );
    cfs = c0s + d - 1;
    
    x = padarray(x,[d,d],0);
    r0s = r0s + d;
    rfs = rfs + d;
    c0s = c0s + d;
    cfs = cfs + d;
    
    
    
% tip toe through the tulips

    for i = 1:size(y,1)
    for j = 1:size(y,2)
    
        cur_chunk = x(r0s(i):rfs(i),c0s(j):cfs(j),:);
        
        z{i,j} = cur_chunk;
        
    end
    end
    
    
    
end
    
    
    
