function [y,ccs,y_mu] = local_prctile_1d(x,d,s,p)

% [y,ccs,y_mu] = local_prctile_1d(x,d,s,p);







% set parameters

    if ~exist('x','var') || isempty(x)
        x = double(imread('cameraman.tif'))/255;
        display('local_max in demo mode'); 
    end

    if ~exist('d','var') || isempty(d); d = round(size(x,1)/20); end
    if ~exist('s','var') || isempty(s); s = d/sqrt(2); end
    if ~exist('p','var') || isempty(p); p = 50; end % median by default
   

    
% allocate for output and define boundary inds

    y    = zeros( round(length(x)/s), length(p) );
    y_mu = zeros( size(y,1), 1 );
   
    ccs = round( linspace( s/2, length(x)-s/2, length(y) ) );
    c0s = round( ccs - d/2 );
    cfs = c0s + d - 1;
    
    c0s( c0s < 1 ) = 1;
    cfs( cfs > length(x) ) = length(x);
   
    
    
    
    
% tip toe through the tulips

    for i = 1:size(y,1)
    
        cur_chunk = x(c0s(i):cfs(i));
        
        y(i,:) = prctile( cur_chunk, p );
        y_mu(i) = mean( cur_chunk );
        
    end
    
    
    
    
end
    
    
    
