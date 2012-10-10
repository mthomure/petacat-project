function [mismatched_image, n_mismatched_pixels] = segment_matching(m,t_n)
%segment_matching(m,t_n) matches segments in pivot image <m> against segments
%in image <t_n> 
%output:
%<mismatched_image> shows total number of mismatched pixels as an image
%<n_mismatched_pixels> is a total number of mismatched pixes im <mismatched_image> 
%input:
%<m>, <t_n> are 2D image arrays showing segment maps indexed with unique integer
%indexes 
%<m> is the pivot segment map
%<t_n> is the segment map copared with  

n = t_n;
%PIVOT image m
%count unique segments in image
[unique_segment_index, unique_segment_count] = count_unique(m);
segment_count=size(unique_segment_index, 1);
for i = 1:segment_count
    %get the largest segment
    [largest_count, largest_index] = max(unique_segment_count);
    %get value of segment's index
    segment_index = unique_segment_index(largest_index);
    %get all indexes of pixels with given segment_index
    image_segment_indexes = find (m==segment_index);

    %OVERLAP image n
    %count overlaping segment pixels in image n over segment in image m
    [unique_segment_index_o, unique_segment_count_o] = count_unique(n(image_segment_indexes'));
    segment_count_o=size(unique_segment_index_o, 1);
    %get the largest overlaping segment 
    [largest_count_o, largest_index_o] = max(unique_segment_count_o);
    %get value of largest overlaping segment's index
    segment_index_o = unique_segment_index_o(largest_index_o);

    % check if segment_index_o is non-negetive aka already matched, o.w. select next largest
    tmp = segment_count_o;
    while segment_index_o < 0 && tmp > 0
        unique_segment_count_o (largest_index_o) = - unique_segment_count_o (largest_index_o);
        %get the largest overlaping segment 
        [largest_count_o, largest_index_o] = max(unique_segment_count_o);
        %get value of largest overlaping segment's index
        segment_index_o = unique_segment_index_o(largest_index_o);
        tmp = tmp -1;
    end
    %get all indexes of pixels with given segment_index in overlap image
    image_segment_indexes_o = find (n==segment_index_o);
    
    %get indexes where pivot and overlap segments overlap for largest area
    indexes_largest_overlap = image_segment_indexes(n(image_segment_indexes') == segment_index_o);
    %mark all pixels in largest overlaping segment in overlap but not in the intersection as negative
   %n(image_segment_indexes_o) = - abs(segment_index_o); 
    %mark all pixels in pivot segment as mis-match (negative)
   %n(image_segment_indexes') = - abs(n(image_segment_indexes'));
    % only mark only pixels in the intersection
    n(indexes_largest_overlap) = - segment_index_o;

    %mark pivot segment and its count as seen (negative)
    unique_segment_index(largest_index) = unique_segment_index(largest_index) * -1;
    unique_segment_count(largest_index) = unique_segment_count(largest_index) * -1;

end
%disp(n);
n_mismatched_pixels = size(find(n>0), 1);
mismatched_image=n;
end

