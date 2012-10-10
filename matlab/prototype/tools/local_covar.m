function [ local_covar ] = local_covar( x, h )

	% [ local_covar ] = local_covar( x, h )
	% h is a 1 or 2 dimensional filter
	% x is a 1 or 2 dimensional input

    if ~exist('h','var') || isempty(h)
        h = gabor(21,0);
        display('local_covar using default filter' );
    end
    if ~exist('x','var') || isempty(x)
        x = double( imread( 'cameraman.tif'))/255;
        display('local_covar using default input (cameraman)');
    end
    
    h_mu  = ones(size(h));
    h_mu  = h_mu / sum(h_mu(:));
    x_mu  = filtern( h_mu, x );

    local_covar = filtern( h-mean(h(:)), x-x_mu ) / sum(h_mu(:));

end





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
    
    
    
