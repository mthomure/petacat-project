


function [ chips, source_coords ] = chipper( x, width, step )

    % [ chips, source_coords ] = chipper( x, width, step )

    if ifndef('x',imread('cameraman.tif'))
        x = double(x)/255; 
        display('chipper is in demo mode'); 
    end
    ifndef('width',11);
    ifndef('step',fix(width/2));

    
    
    r0s = 1:step:size(x,1);
    rfs = r0s + width - 1;
    c0s = 1:step:size(x,2);
    cfs = c0s + width - 1;
    
    r0s( gt(rfs,size(x,1)) ) = [];
    rfs( gt(rfs,size(x,1)) ) = [];
    
    c0s( gt(cfs,size(x,2)) ) = [];
    cfs( gt(cfs,size(x,2)) ) = [];
    
    
    
    chips = zeros( length(r0s) * length(c0s), width * width * size(x,3) );
    source_coords = zeros( size(chips,1), 4 );
    k = 1;
    for i = 1:length(r0s)
    for j = 1:length(c0s)
        
        cur_chip = x(r0s(i):rfs(i),c0s(j):cfs(j),:);
        chips(k,:) = reshape( cur_chip,1,[] );
        
        source_coords(k,:) = [r0s(i),rfs(i),c0s(j),cfs(j)];
        
        k = k + 1;
        
    end
    end
    
   
    
end
    
    
    
    
    
    