function y = tukey( n, alpha )

% y = tukey( n, alpha )
% alpha defaults to .5
% alpha == 1 => hann window
% alpha == 0 => rectangle window

    
    if ~exist('alpha','var') || isempty(alpha)
        alpha = .5;
    end

    
    if alpha > 0 && alpha < 1 
        x1 = hann( round( n*(alpha/2) ) );
        x2 = ones( round( n *(1-alpha/2) ), 1 );
        y = conv(x1,x2);
        y = [y; zeros(n-length(y),1)];
    elseif alpha <= 0
        y = ones( n,1 );
    else
        y = hann( n );
    end
    
    y = y/max(y);
        
end
    
    
    
    
    
    
     