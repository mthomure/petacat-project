function fold_inds = k_fold_inds_block(class,k)
    
    % fold_inds = k_fold_inds_block(class,k);
    % returns group inds for each exemplar
    % groups the first  1/k of class 0 with the first  1/k of class 1
    % groups the second 1/k of class 0 with the second 1/k of class 1, etc


    if ifndef('k',10)
        display('k_fold_inds_block k not specified, using 10');
    end
    
    
    % get indicies for each class
    class0_inds = find( ~class );
    class1_inds = find(  class );

    % assign each example to a group from 1:k
    % linear from 1 to k+1, then trim off the last element (k+1) and round down.
    class0_groups = fix(linspace(1,k+1,length(class0_inds)+1));
    class0_groups(end) = [];

    % same for the other class
    class1_groups = fix(linspace(1,k+1,length(class1_inds)+1));
    class1_groups(end) = [];

    z = [class0_inds(:) class0_groups(:); ...
         class1_inds(:) class1_groups(:) ];

    z = sortrows(z);
    
    fold_inds = z(:,2);
    
    
    
end
