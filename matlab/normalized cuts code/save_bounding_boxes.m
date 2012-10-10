function save_bounding_boxes(fn, bounding_boxes )
%Save <bounding_boxes> array to a new file <fn>
%input:
%<fn> file name 
%<bounding_boxes> is an array where each array row represents one bounding box
%and each column represents box's [x_coord, y_coord, width, height]

dlmwrite(fn, bounding_boxes, 'delimiter', '\t');

end

