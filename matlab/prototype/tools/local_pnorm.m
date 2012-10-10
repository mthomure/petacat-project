function y = local_pnorm( x, p, m )

    % y = local_pnorm( x, p, m );
    %
    %   x is the signal
    %   p is the norm
    %   m is the window width

    h = ones(1,m) / m;
    % y = filtfilt( h, 1, (abs(x)).^p );
    y = conv( (abs(x)).^p, h, 'same' );
    y = y .^ (1/p);
    
end