function [] = petacat_boundingbox_script( ...
    image_name , results_path , num_boxes )
% petacat_boundingbox_script( image_name , results_path , num_boxes )
%
% Extracts bounding boxes from image_name, and writes them to results_path
% as .mat files, encoding uint8 data (0 = black, 255 = white).
%
% example usage:
%
% petacat_boundingbox_script( 'dogwalking3.jpg', 'results/dogwalking3/', 5 );
%
% Note that the image needs to be in Matlab's search path.


mkdir( results_path );



fname = { image_name };



[centroids,boxes] = ...
    hmax_attentional_bounding_boxes( fname, num_boxes, false);
    % 'false' as the final argument: stops figures from being drawn.
    
    
bag_of_boxes = create_bag_of_boxes( fname, boxes );
% returns a cell array of images



write_bounding_boxes( bag_of_boxes, results_path );
% writes data to disk