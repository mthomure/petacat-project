function [output,cum_sum] = radial_sum(input,verbose)



    % [output,cum_sum] = radial_sum(input,verbose);
    % add up around the cirlce!


    
    d = 50;
    if ifndef( 'input',   padarray( disk(d), [d/2 d/2] ) );
        display('radial sum is in demo mode');
        ifndef( 'verbose', true );
    else
        ifndef( 'verbose', false );
    end

    

    N = size(input);
    [xmesh,ymesh] = meshgrid(linspace(-1,1,N(1)),linspace(-1,1,N(2)));
    r_grid = sqrt( xmesh.^2 + ymesh.^2 );

    steps = fix( N(1) / 4 );
    radius_vals = linspace( 0, 1, steps );
    for i = 1:length(radius_vals)

        cur_r = radius_vals(i);
        cur_pix = input( le(r_grid,cur_r));
        cum_sum(i) = sum(cur_pix(:));

    end
    
    output = diff([0 cum_sum]);
    
    
    
    if verbose
        
        figure;
        subplot(1,3,1);
        imshow(input,[]);
        subplot(1,3,2);
        plot( linspace(0,1,length(cum_sum)), cum_sum );
        subplot(1,3,3);
        plot( linspace(0,1,length(output)), output );
        
    end

    
    
end






