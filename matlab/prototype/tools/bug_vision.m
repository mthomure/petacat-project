function [image,y,rcs,ccs] = bug_vision(x,d,s)

% [image,y,rcs,ccs] = bug_vision(x,d,s);
%   x is the input map. if there are multiple layers, all layers will be pooled over for a given spatial location
%   d is the diameter over which to take the max (diameter)
%   s is the number of pixels between sampling centers (step size)
%
%   if d is specified and s is not, s will default such that all pixels are
%   included in at least one neighborhood, and the overlap between circular
%   neighborhoods is minimized
%
%   y is the output map
%   rcs are the row coordinates of the centers with respect to x
%   ccs are the column coordinates of the centers with respect to x
%
%   also see local_extrema









% set parameters

    if ~exist('x','var') || isempty(x)
        x = double(imread('cameraman.tif'))/255;
        display('local_max in demo mode'); 
    end
    if ~exist('d','var') || isempty(d); d = round(size(x,1)/20); end
    if ~exist('s','var') || isempty(s); s = d/sqrt(2); end
   

% allocate for output

    y = cell( round(size(x,1)/s), round(size(x,2)/s) );
    
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
    
    mask = repmat( disk(d), [1 1 size(x,3)] );
    
    
    
% tip toe through the tulips

    image = [];
    for i = 1:size(y,1)
        
        row_temp = [];
        
    for j = 1:size(y,2)
    
        
        cur_chunk = x(r0s(i):rfs(i),c0s(j):cfs(j),:);
        cur_chunk = mask .* cur_chunk;
        
        row_temp = [ row_temp cur_chunk ];
        
        y{i,j} = cur_chunk;
        
    end
    
        image = [image; row_temp ];
    
    end
    
    
    
    
    
    
end
    
    
    
