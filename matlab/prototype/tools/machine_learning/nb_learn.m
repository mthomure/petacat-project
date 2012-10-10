function [mu, sigma, class_p, class, Posterior_numerator] = nb_learn( x, y )



    % [mu, sigma, class_p, class, Posterior_numerator] = nb_learn( x, y );
    % 
    % naive bayes classify assuming normal distributions
    %
    % x: data, rows are instances, columns are features
    % y: class label
    %
    % mu,sigma,class_p represent the learned model
    % each has a column for each class from y, given in the order "class"
    % Posterior_numberator is for the training data
    
    
    
    class = unique(y);
    
    for ci = 1:length(class)
        
        mu(ci,:)     = mean( x( eq(class(ci),y), : ) );
        sigma(ci,:)  = std(  x( eq(class(ci),y), : ) );
        
        class_p(ci) = mean( eq( class(ci), y ) );

    end
    
    
    
    if nargout > 4
        Posterior_numerator = nb_classify( x, mu, sigma, class_p );
    end
    
    
    
end
    
    
   
    
    
    
    