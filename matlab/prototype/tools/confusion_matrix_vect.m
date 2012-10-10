function ...
    [confusion_matrix_count, confusion_matrix_ratio, error_list] ...
        = confusion_matrix_vect( classif_vect, label_vect )

    
%    
% classif_vect = classifications provided by your classifier
% label_vect   = the ground truth classes
%
% a column of either confusion matrix shows you how a particular label was
% classified. That is, columns should sum to 1, and rows should indicate a
% bias toward a particular classification.
%
% error_list has three columns
%   column 1: the element that caused the error
%   column 2: the correct label
%   column 3: the class that the classifier selected
% 
% n = 20;
% label_vect = [zeros(1,n) ones(1,n)];
% classif_vect = [gt(rand(1,n),.8) lt(rand(1,n),.8)];
% [confusion_matrix_count, confusion_matrix_ratio, error_list] ...
%         = confusion_matrix_vect( classif_vect, label_vect );
%



    unq_labels = unique([classif_vect(:),label_vect(:)]);
    classification = eq( repmat(classif_vect(:),1,length(unq_labels)), repmat(unq_labels',length(classif_vect),1) );
    label = eq( repmat(label_vect(:),1,length(unq_labels)), repmat(unq_labels',length(label_vect),1) );

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