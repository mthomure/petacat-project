function [ boxes ] = box_segments(image)
%BOX_SEGMENTS takes <image> that is a segmented images showing all segments
%as unique segmentation indexes.
% retrunes <boxes> that are rectangles outlining all segments
% each line of boxes represents one rectangle box with [x, y, w, h] 
[unique_index, unique_count] = count_unique(image);
segment_count = size (unique_index, 1);
boxes=zeros(segment_count, 4);
boxes_image=image;
%for each segment find min and max X,Y coord and record in boxes
%figure
for i=1:segment_count
   segment_indexes=find(image==unique_index(i));
   [Y,X] = ind2sub(size(image), segment_indexes);
   boxes(i, 1)= min(X);
   boxes(i, 2)= min(Y);
   boxes(i, 3)= max(X)-boxes(i,1);
   boxes(i, 4)= max(Y)-boxes(i,2);
   %rectangle('Position', [boxes(i, 1),boxes(i, 2), boxes(i, 3)-boxes(i, 1), boxes(i, 4)-boxes(i, 2)]);
end

end

