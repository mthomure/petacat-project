function y = blackman_cdf( x, x0, xf, n )

    if nargin < 1; x = linspace(0,1,100); end
    if nargin < 3; x0 = 0; xf = 1; end
    if nargin < 4; n = 2*length(x); end
    
    x(lt(x,x0)) = x0;
    x(gt(x,xf)) = xf;
    
    u = abs( cumsum(blackman(n)) / sum(blackman(n)) );
    i = fix((n-1) .* (x-x0) ./( xf-x0)) + 1;
    
    y = u(i);
    
end
    