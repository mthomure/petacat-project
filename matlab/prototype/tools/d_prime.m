function d = d_prime(x,y)

    % calculates the dprime for a set of labeled data
    %
    % x are decision variables
    % y are labels (binary)
    % d is the distance, assuming normality, in terms of stds of outclass 
    %
    % that is, d_prime = ( mu_1 - mu_0 ) ./ sigma_0;

    mu_0 = mean( x(~y,:) );
    mu_1 = mean( x( y,:) );
    
    % sigma = std( [x(~y,:) - repmat(mu_0,sum(~y,1),1) ; ...
    %               x( y,:) - repmat(mu_1,sum( y,1),1) ] );
    
    sigma_0 = std( x(~y,:) );
    
    d = ( mu_1 - mu_0 ) ./ sigma_0;
    
end