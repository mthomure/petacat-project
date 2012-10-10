function [AUROC_mean, AUROC_k, dvars_test, label_test, AUROC_train_mean] = k_fold_classify(x,label,k)

% [AUROC_mean, AUROC_k, dvars_test, label_test, AUROC_train_mean] = k_fold_classify( x, label, k );
%
% classifies the data in 1/k sized, sequential blocks
% sequential blocks are important for EEG
% features are taken from overlapping windows
% blocks prevent significant amounts of data from appear 
% in both training and testing sets
% 
% x should have instances in rows, features in columns
% label should be true/false
% k defaults to 10 if not specified
% 
% AUROC_mean is the average AUROC value over the k folds
% AUROC_k    holds the AUROC for each of the k folds


    use_logistic_regression = false;


    if ifndef('x',0)
        
        display( 'classify function is in demo mode' );
        
        z = load([data_fft_path() 'data_psd_s2_26-Oct-2011']);
        channel = 17;
        x = z.psd_log(channel,:,:);
        x = shiftdim(x,2);
        x = reshape( x, size(x,1), [] );
        
        label = z.class_label;
       
    end
    
    
    if size(x,1) ~= length(label)
        display('error in k_fold_classify: the size of data x and the length of the labels are not compatible');
    end
    
    
    ifndef('k',2);
    
    k_inds = k_fold_inds_block(label,k);
  
    AUROC_k = zeros(1,k);
    
    for ki = 1:k
        
        x_test  = x(  eq(k_inds,ki), : );
        x_train = x( ~eq(k_inds,ki), : );
        
        label_test{ki} = label(  eq(k_inds,ki) );
        label_train    = label( ~eq(k_inds,ki) );
        
        if use_logistic_regression
            
            B = mnrfit(x_train,label_train+1);
            p = mnrval(B,x_test);
            dvars_test{ki} = p(:,2);
        
        else % use linear discriminant analysis
            
            [W, ~] = LDA( x_train, label_train );
            
            dvars_train = x_train * W;
            dvars_test{ki} = x_test * W;
            
        end

        AUROC_train_k(ki) = ROC( dvars_train, label_train, 1 );
        AUROC_k(ki) = ROC( dvars_test{ki}, label_test{ki}, 1 );

    end

    
    
    AUROC_mean = mean(AUROC_k);
    AUROC_train_mean = mean(AUROC_train_k);
    
    
    
end














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


