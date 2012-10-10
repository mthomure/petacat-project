function [W, dvars, threshold] = LDA( data, labels )

    % [W, dvars, threshold] = LDA( data, labels );
    %    
    % data: rows are exemplars, columns are features
    % labels: a single column of 0s and 1s
    %
    % dvars is the transformed data. high values should be class 1
    % W is the transformation matrix (data * W = dvars)
    % threshold is selected by max( tpr - fpr )
    
    mu_0 = mean( data( eq(labels,0),: ) );
    mu_1 = mean( data( eq(labels,1),: ) );
    cov_0 = cov( data( eq(labels,0),: ) );
    cov_1 = cov( data( eq(labels,1),: ) );
        
    % W = inv( cov_0 + cov_1 ) * ((mu_1 - mu_0)');
    
    warning('off');
    W = ( cov_0 + cov_1 ) \ ((mu_1 - mu_0)');
    warning('on');
    
    
    
    
    if nargout > 1
    
        dvars = data * W;
        
    end
    
    
    if nargout > 2
        
       [~,tpr,fpr,thresholds] = ROC( dvars, labels );
       [~,i] = max( filtfilt( ones(10,1), 1, tpr-fpr ) );
       threshold = thresholds(i);
        
    end
    
end