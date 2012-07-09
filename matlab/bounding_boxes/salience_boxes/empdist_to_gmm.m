
function [mu,Sigma] = empdist_to_gmm( x, k )

    % [mu,Sigma] = empdist_to_gmm( x, k );
    %
    % builds a gaussian mixture model with k gaussians
    % from an empirical distribution (image)
    %
    % follow with:
    %   coords = gmm_box_coords(mu,Sigma) 
    % to get bounding coords on the result, and 
    %   draw_box(coords)
    % to see the resulting boxes

    demo_mode = false;
    if ~exist('x','var') || isempty(x)
        
%         x = zeros( 300,500 );
%         x( 100,100 ) = 1;
%         x( 120,150 ) = 1;
%         x( 200,300 ) = 1;
%         x( 250,300 ) = 1;
%         h = blackman(100)*blackman(100)';
%         x = filtern(h,x);
%         x = mat2gray(x);
%     
        
        x = imread('fruit.jpg');
        x = rgb2gray(x);
        x = filtern( blackman(100)*blackman(100)', x);
        x = mat2gray(x) - .5;
        
        demo_mode = true;
        
    end
    
    if ~exist('k','var') || isempty(k)
      k = 5;
    end
    
    
    
    
    
% sample
    n_levels = 5;
    levels = linspace(min(x(:)),max(x(:)),n_levels+1);
    levels(1) = [];
    levels(end) = [];

    d = [];
    for li = 1:length(levels)

        [rs, cs] = find( gt(x,levels(li)) );
        d = [d; [rs cs]];

    end
    
    m = 20000;
    if size(d,1) > m
        d = d( randperm(size(d,1)),:);
        d = d(1:m,:);
    end
    

% model
    options = statset('Display','final');
    num_reps = k;
    gm = gmdistribution.fit(d,k,'Options',options,'Replicates',num_reps);
    mu = gm.mu;
    Sigma = gm.Sigma;
    
    
    
% display
    if demo_mode
        figure;
        imshow(.75*mat2gray(x)+.25);
        hold on;
        plot(d(1:500,2),d(1:500,1),'.r');
        coords = gmm_box_coords( mu, Sigma, 1.5 );
        hold off;
    end
    
    
    
end
    


    
    
    
    
    
    