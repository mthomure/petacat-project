function [y_max, y_min] = local_max_vect(x,d)

    % [y_max, y_min] = local_max_vect(x,d);
    % x should have a few rows, and many columns

    [r,c] = size(x);
    y_max = zeros(r,c);
    y_min = zeros(r,c);
    
    for i = 1:r
    for j = 1:c
        
        r0 = max(1, i - ceil(d/2));
        rf = min(r0 + d, r);
        c0 = max(1, j - ceil(d/2));
        cf = min(c0 + d, c);
        
        cur_chunk = x(r0:rf,c0:cf);
        
        y_max(i,j) = max(cur_chunk(:));
        y_min(i,j) = min(cur_chunk(:));
%         
%         if mod(j,100)==0
%         fprintf('.');
%         end
        
    end
    end
    
end