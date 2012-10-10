


function h = gabor( m, r )

    % h = gabor( m, r )
    %   m is dimension
    %   r is rotation
    %   uses a centered sine function (edge detector, not line)

    if ~exist('r','var') || isempty(r)
        r = 0;
    end
    if ~exist('m','var') || isempty(m)
        m = 11;
    end
    
    env = blackman(m) * blackman(m)';
    x = ones(m,1) * sin( linspace(-2*pi,2*pi,m) ) ;
    x = imrotate(x,r,'bilinear','crop');
    
    h = env .* x;
    
end
    
    
    





