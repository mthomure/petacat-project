

function [selected, AUROCs] = SFFS(x,class)



    % [ selected, AUROCs ] = SFFS( x, class );
    %
    % Sequential Floating Forward Selection (SFFS) is a dimensionality reduction 
    % heuristic that greedily orders a feature set by how much the improve 
    % classification assuming the inclusion of all previously selected 
    % features. 
    %
    % This implementation uses Linear Discriminant Analysis (LDA)
    % for classification and the resulting Area Under the Reciever
    % Operating Characteristic (AUROC) to evaluate the feature
    %
    % x:      has instances in rows, features in columns
    % class:  contains the class labels of x (0,1)
    %
    % selected:   is an interger sequence indexing the selected features of x
    % AUROCs(n):  is the AUROC value from the LDA using features 1:n (from
    %   the output indexing of features in x

    
    
    pool     = 1:size(x,2);
    selected = [];
    
    AUROC_per_subset = [];

    
    
    for j = 1:length(pool)

        AUROC  = zeros(1,length(pool));
        for i = 1:length(pool)
            [~, d_vars]      = LDA( x(:,[selected  pool(i)]), class );
            [~, ~, AUROC(i)] = ROC( d_vars, class, 1 );
        end

        best_ind = find( eq(AUROC,max(AUROC)), 1 );
        selected = [selected pool(best_ind)];
        pool(best_ind) = [];
        
        AUROC_per_subset(j) = max(AUROC);
        
    end
    
    
    
    AUROCs = AUROC_per_subset;
    
    
    
end
    
    

            
         




