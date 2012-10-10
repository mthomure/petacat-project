function [ boxes_image ] = fix_discontinuous_segments ( image )
%check if all segments are continuous if a segment is not continous, pick
%one subsegment and assign it new segment index
%input:
%<image> segment map with each segment assigned unique index starting at 1
%to n segments.
%output:
%<image> segment map with fixed segments so each segment is continous and 
%assigned unique segment index.

[unique_index, unique_count] = count_unique(image);
segment_count = size (unique_index, 1);
boxes=zeros(segment_count, 4);
boxes_image=image;
[height, width, r] = size(image);
%for each segment find continous segments and record in boxes figure
for i=1:segment_count
   segment_indexes=find(image==unique_index(i));
   [Y,X] = ind2sub(size(image), segment_indexes);
   segment_size=size(X,1);
   boxes_image(Y(1),X(1)) = -i;
   nei = get_neighborhood(Y(1), X(1), height, width);  
%   for p = 1 : segment_size    
       for p = 1 : segment_size
          for z1 = 1 : 9
            if (nei(z1, 1) == Y(p)) &&  (nei(z1, 2) == X(p))
                 boxes_image(Y(p), X(p)) = -i;
            end
%       end
        end
   end
end
end

function [nei] = get_neighborhood (x, y, height, width)
    nei=zeros(9,2);
    top_row = x - 1;
    bot_row = x + 1;
    left_col = y - 1;
    right_col = y+1;
    if top_row == 0
        top_row = 1;
    end
    if bot_row > height
        bot_row = height;
    end
    if left_col == 0;
        left_col =1;
    end
    if right_col > width
        right_col = width;
    end
    nei(:,:,1)=[top_row left_col; top_row y; top_row right_col; 
        x left_col; x y; x right_col; 
        bot_row left_col; bot_row y; bot_row right_col];
end
