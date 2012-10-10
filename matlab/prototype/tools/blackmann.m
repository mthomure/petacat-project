function y = blackmann(r,c,d)

    if nargin < 2; c = r; d = 1; end
    if nargin < 3; d = 1; end
    
    x1 = blackman(r);
    x2 = blackman(c);
    y = repmat(  x1 * x2', [1, 1, d] );
    
end

    