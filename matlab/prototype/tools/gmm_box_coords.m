function [coords] = gmm_box_coords( mu, Sigma, n )
   
    % box_gmm( mu, Sigma, n )
    %
    % determines coordinates for rectilinear bounding boxes for 
    %   a gaussian mixture model
    % mu and Sigma define the gaussian mixture model
    %
    % n is the number of standard deviations out to draw the box
    % if not specified, it defaults to 3;
    
    if ~exist('n','var') || isempty(n)
        n = 3;
    end

    sigma = sqrt( Sigma );
    
    % define boxes
        coords = zeros(size(mu,1),4);
        for bi = 1:size(mu,1);
            r0 = mu(bi,2) -   n*sigma(2,2,bi);
            rf = r0       + 2*n*sigma(2,2,bi);
            c0 = mu(bi,1) -   n*sigma(1,1,bi);
            cf = c0       + 2*n*sigma(1,1,bi);
            coords(bi,:) = [r0 c0 rf cf];
        end
    
    % draw boxes
        % draw_box(coords);
        
end
