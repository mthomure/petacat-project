
function [ x_mu, x_var, x_sig ] = local_stat( x, m )

    % [ x_mu, x_var, x_sig ] = local_stat(x,m);
    % x is the signal
    % m is the width of the neighborhood being considered

    for ri = 1:size(x,1)
        x_mu(ri,:)  = (1/m) * conv( x(ri,:),    ones(1,m), 'same' );
        x2_mu(ri,:) = (1/m) * conv( x(ri,:).^2, ones(1,m), 'same' );
    end
    
    x_var = (x2_mu - x_mu.^2);
    x_sig = x_var .^ (1/2);
    
end