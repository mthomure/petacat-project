function [Posterior_numerator] = nb_classify( x, mu, sigma, class_p )



    % [Posterior_numerator] = nb_classify( x, mu, sigma, class_p );
    % 
    % naive bayes classify assuming normal distributions

    
    
    n = size(x,1);
    m = size(x,2);
    
    Conditional = zeros(n,m);
    for ci = 1:m
        Conditional(:,ci) =  prod( normpdf( x, repmat(mu(ci,:),n,1), repmat(sigma(ci,:),n,1) ), 2 );
    end
    
    Class_probability = repmat(class_p,n,1);
    
    Posterior_numerator = Conditional .* Class_probability;
    
    
end
    
    
   
    
    
    
    