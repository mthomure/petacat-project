function [ corr_win, cov_win, x_mu, x_sig ] = corr_windowed( h, x )

    % [ corr_win, cov_win, x_mu, x_sig ] = corr_windowed( h, x );
    % window for x_mu and x_sig is the width of the vector h;
    %
    % THIS IS FOR VECTORS, not images


    demo_mode = false;

    if ~exist('h','var') || isempty(h)
        
        m = 50;
        h = sin( linspace( -2*pi, 2*pi, m ) ) .* blackman(m)';
        
        demo_mode = true;
        display('corr_windowed in demo mode');
        
    end
    
    if ~exist('x','var') || isempty(x)
        
        x = zeros( 1000, 1 );
        x( 300 ) = 2;
        x( 600 ) = .5;
        x = filter(h,1,x);
        x = x + .05*randn(length(x),1); % because we can't deal with 
        
        demo_mode = true;
        display('corr_windowed in demo mode');
        
    end
    
    
    if prod(size(x)) == length(x)

        m     = length(h);
        h_mu  = mean(h);
        h_sig = std(h);

        x_mu  = (1/m) * conv( x,    ones(1,m), 'same' );
        x2_mu = (1/m) * conv( x.^2, ones(1,m), 'same' );
        x_sig = (x2_mu - x_mu.^2) .^ (1/2);

        cov_win = (1/m) * conv( x - x_mu, h(end:-1:1) - h_mu, 'same' );
        corr_win = cov_win ./ ( h_sig * x_sig ); 
        
    else
        
        for ri = 1:size(x,1)
            [ corr_win(ri,:), cov_win(ri,:), x_mu(ri,:), x_sig(ri,:) ] = corr_windowed( h, x(ri,:) );
            fprintf('.');
        end
        
    end
        

    
    if demo_mode
        
        figure; 
        subplot(1,5,1); plot(h);
        subplot(1,5,[2 5]);
        hold on; 
        plot(x/std(x),'b'); 
        plot(cov_win/std(cov_win),'r'); 
        plot(corr_win/std(corr_win),'g'); 
        legend('signal','covariance','correlation');
        hold off;   
       
    end
    
    
end




