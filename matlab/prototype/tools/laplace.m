function [pdf,cdf,cdf_inv] = laplace(x,mu,b)

% [pdf,cdf,cdf_inv] = laplace(x,mu,b);

    if ~exist('x')  || isempty(x),      x = linspace( -10,10,101 ); end
    if ~exist('mu') || isempty(mu),     mu = 0;                     end
    if ~exist('b')  || isempty(b),      b = 1;                      end

    f = @(x,mu,b) 1/(2*b) * exp( -1 *  abs(x-mu) / b );
    F = @(x,mu,b) .5 * (1 + sign(x-mu).*(1 - exp(-1*abs(x-mu)/b)));
    F_inv = @(x,mu,b) mu - b*sign( x - .5 ) .* log( 1 - 2*abs(x - .5) );
    
    pdf = f(x,mu,b);
    cdf = F(x,mu,b);
    cdf_inv = F_inv(x,mu,b);
    
end
    
    
    
    