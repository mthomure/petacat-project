function [y,rcs,ccs] = local_prctile(x,d,s,p)

% [y,rcs,ccs] = local_prctile(x,d,s,p);
%   x is the input map. if there are multiple layers, all layers will be pooled over for a given spatial location
%   d is the diameter over which to take the max (diameter)
%   s is the number of pixels between sampling centers (step size)
%   p are the percentiles to record [5 25 50 75 95]
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
%   also see local_prctile_1d









% set parameters

    if ~exist('x','var') || isempty(x)
        x = double(imread('cameraman.tif'))/255;
        display('local_max in demo mode'); 
    end

    if ~exist('d','var') || isempty(d); d = round(size(x,1)/20); end
    if ~exist('s','var') || isempty(s); s = d/sqrt(2); end
    if ~exist('p','var') || isempty(p); p = 50; end % median by default
   

    
% allocate for output

    y = zeros( round(size(x,1)/s), round(size(x,2)/s), length(p) );
    
    rcs = round( linspace( s/2, size(x,1)-s/2, size(y,1) ) );
    r0s = round( rcs - d/2 );
    rfs = r0s + d - 1;
    
    ccs = round( linspace( s/2, size(x,2)-s/2, size(y,2) ) );
    c0s = round( ccs - d/2 );
    cfs = c0s + d - 1;
    
    % instead of padding, 
    
    inclusion_map = true(size(x));
    inclusion_map = padarray(inclusion_map,[d,d],false);
    inclusion_disk = logical(round(disk(d)));
    
    x = padarray(x,[d,d],0);
    r0s = r0s + d;
    rfs = rfs + d;
    c0s = c0s + d;
    cfs = cfs + d;
    
    
    
    
% tip toe through the tulips

    for i = 1:size(y,1)
    for j = 1:size(y,2)
    
        cur_chunk = x(r0s(i):rfs(i),c0s(j):cfs(j),:);
        inclusion = and( inclusion_map(r0s(i):rfs(i),c0s(j):cfs(j),:), inclusion_disk );
        cur_chunk = cur_chunk( inclusion );
        
        y(i,j,:) = prctile( cur_chunk, p );
        
    end
    end
    
    
    
    
end
    
    
    
