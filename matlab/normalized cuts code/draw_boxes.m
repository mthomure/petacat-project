function [ image ] = draw_boxes( boxes, image )
%draw_boxes, draws boxes around imagesegments 

figure(10);
imagesc(image);
for i=1:size(boxes, 1)
   rectangle('Position', boxes(i, :));
end

end

