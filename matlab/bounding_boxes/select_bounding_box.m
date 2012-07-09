function chosen_bounding_box = select_bounding_box( ...
    bag_of_boxes , heuristic_info )
% chosen_bounding_box = select_bounding_box( bag_of_boxes , heuristic_info )
%
% chosen_bounding_box is an image, chosen (according to some specified
% heuristic) from the input bag_of_boxes.
%
% bag_of_boxes is a cell array of potential boxes that we might want to
% choose.
%
% Currently, the choosing heuristic is random. In the future, we will want
% to choose the bounding box based on some information. The variable
% heuristic_info will store this information, but it is currently unused.
%
% For example, 'heuristic_info' might be the location of the bounding
% boxes, or some previous computed features.


num_boxes = numel( bag_of_boxes );



%% Choose the index of the bounding box
random_index = randi( num_boxes );



%% Return the chosen bounding box
chosen_bounding_box = bag_of_boxes( random_index );