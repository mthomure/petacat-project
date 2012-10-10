function [ chips, source_coords ] = chipper_rand_n( x, width, n )

    % [ chips, source_coords ] = chipper_rand_n( x, width, n );
    %
    % generates a nearly exhaustive collection of bounding box coordinates
    % that could be used to chip x.
    % then uniformly samples from the list and generates chips.
    % chips are turned to 1 dimensional vectors for easy processing.
    % original coords are recorded in source_coords
    
    if ~exist('x','var') || isempty(x)
        x = imread('cameraman.tif');
        x = double(x)/255; 
        display('chipper is in demo mode');
    end
    
    
    if ~exist('width','var') || isempty(width)
        width = 11;
    end
    
    
    if ~exist('n','var') || isempty(n)
        n = 10;
    end
    
    

    
    step = round(width/2);
    r0s = 1:step:size(x,1);
    rfs = r0s + width - 1;
    c0s = 1:step:size(x,2);
    cfs = c0s + width - 1;
    
    r0s( gt(rfs,size(x,1)) ) = [];
    rfs( gt(rfs,size(x,1)) ) = [];
    
    c0s( gt(cfs,size(x,2)) ) = [];
    cfs( gt(cfs,size(x,2)) ) = [];
    
    r_inds = randi(length(r0s),[1,n]);
    r0s = r0s(r_inds);
    rfs = rfs(r_inds);
    
    c_inds = randi(length(c0s),[1,n]);
    c0s = c0s(c_inds);
    cfs = cfs(c_inds);
    
    
    chips = zeros( length(r0s), width * width * size(x,3) );
    source_coords = [r0s' rfs' c0s' cfs'];
    for i = 1:length(r0s)
    
        cur_chip = x(r0s(i):rfs(i),c0s(i):cfs(i),:);
        chips(i,:) = reshape( cur_chip,1,[] );
        
    end
    
   
    
end