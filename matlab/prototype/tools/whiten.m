function [xu] = whiten(x)

    xu = x - repmat(mean(x,2),1,size(x,2));
    [E,D] = eig( cov(xu') );
    Du = diag( diag(D).^(-.5), 0 );
    xu = E * Du * E' * xu;
    
end