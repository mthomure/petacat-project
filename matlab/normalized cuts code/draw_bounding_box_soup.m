function [ image ] = draw_bounding_box_soup( image, bounding_boxes )
%draws overlay <bounding_boxes> on <image>
%input:
%<image> source image to serve as background
%<bounding_boxes> 2D array returned by bounding_box_soup where each row
%represents one bounding box and 4 columns represent [x coors, y coord,
%width, height] of a bounding box

figure(10);
imagesc(image);
for i=1:size(bounding_boxes, 1)
    col=1/(bounding_boxes(i,3)+bounding_boxes(i,4));
    h=rectangle('Position', bounding_boxes(i, :), 'FaceColor', 'r');
    disp('Press a key for next rectangle')
    pause;
    set(h, 'FaceColor', 'none');
end

end

