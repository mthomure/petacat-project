function [confusion_matrix_count, confusion_matrix_ratio, error_list] = confusion_matrix( classification, label )
    %
    % [confusion_matrix_count, confusion_matrix_ratio, error_list] = confusion_matrix( classification, label );
    %
    % inputs are expected to be in matrices with rows for exemplars and
    % columns for possible labels
    %
    % classification is a matrix of classifier outputs
    % label is a matrix of the ground truth labels 
    %
    % the confusion matrix will be a square matrix with side length equal
    % the the number of columns in the input matrices
    
    confusion_matrix_count = zeros( size(classification,2) ); 
    
    M = repmat( 1:size(classification,2), size(classification,1), 1 );
    % 1 2 3
    % 1 2 3 
    % 1 2 3
    
    r = sum( classification .* M, 2);
    c = sum( label .* M, 2 );
    
    cur_er = 1;
    
    for i = 1:length(classification)
        confusion_matrix_count( r(i), c(i) ) = ...
            confusion_matrix_count( r(i), c(i) ) + 1;
        
        if r(i) ~= c(i)
            error_list(cur_er,1) = i;
            error_list(cur_er,2) = c(i);
            error_list(cur_er,3) = r(i);
            cur_er = cur_er + 1;
        end
            
    end
    
    confusion_matrix_ratio = ...
        confusion_matrix_count ./ ...
        repmat( sum(confusion_matrix_count), size( confusion_matrix_count,1), 1);
    
end
    
    
   
    
    