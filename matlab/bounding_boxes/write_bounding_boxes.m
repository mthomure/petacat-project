function [] = write_bounding_boxes( bag_of_boxes, path )
% write_bounding_boxes( bag_of_boxes, path );
%
% Writes each bounding box to a file.
%
% 'bag_of_boxes' is a cell array of image boxes, and 'path' is a string
% specifying where to write the data. The data will be written as:
%
%       path/bbox_1.mat , path/bbox_2.mat , ... path/bbox_N.mat

num_boxes = numel( bag_of_boxes );

for i = 1:num_boxes
    
    bbox = bag_of_boxes{i};
    
    
    % change color to grayscale
    if ndims(bbox) == 3
        bbox = rgb2gray( bbox );
    end
    
    
    
    file_string = [ path , '/bbox_' , num2str(i) , '.mat' ];
    
    save( file_string , 'bbox' ); % 'bbox' does indeed need to be a string
    
    
end