function bag_of_boxes = create_bag_of_boxes( fnames , coords )
% bag_of_boxes = attentional_bag_of_boxes( fnames , coords )
%
% bag_of_boxes is a cell array, where each cell is a piece of an image. The
% images are specified by 'fnames', a cell array of image locations. The box
% coordinates are specified by 'coords', a cell array of matrices
% describing the upper-left and lower-right coordinates of the box to crop.
%
% e.g.,  fnames = { 'data/im1.png' , 'data/im2.png', ... , 'data/imN.png' }
%
%        coords = { coords_for_im1 , coords_for_im2, ... , coords_for_imN }
%
% where coords_for_im1 = { [upperLeftX , upperLeftY , 
%                           lowerRightX , lowerRightY ] ,
%                           ...
%                           [upperLeftX , upperLeftY ,
%                           lowerRightX , lowerRightY ] }
%
% and the number of coordinates do NOT need to be the same across all
% images.


%% how many boxes total?

num_images = numel( fnames );
num_boxes  = 0;
box_idx    = 0; % counter for later


for i = 1:num_images
    
    
    num_boxes = ...
        num_boxes + ...
        size( coords{i} , 1 );
        
    
end


%% pre-allocates boxes

bag_of_boxes = cell( num_boxes , 1 );



%% for each image,

for i = 1:num_images
    
    
    
    %% load image and coordinates
    
    current_image        = imread( fnames{i} );
    current_coords       = coords{i};
    [numCols, numRows, ~ ] = size( current_image );
    
    
    
    %% gather boxes
    
    for b = 1:size( current_coords , 1 )
        
        % index of current box in output cell
        box_idx = box_idx + 1;
        
        
        % current box coordinates are the b'th row
        c  = current_coords( b , : );
        
        
        % 'c' is a column vector describing the corners of the crop.
        % Unpack the coordinates.
        % However, don't allow indices to go outside the image boundaries.
        r0 = max( c(1) ,       1 );
        c0 = max( c(2) ,       1 );
        rf = min( c(3) , numRows );
        cf = min( c(4) , numCols );
        
        
        % assume color image
        bag_of_boxes{ box_idx } = ...
            current_image( c0:cf , r0:rf , : );
        
        
    end
    
    
    
    
end