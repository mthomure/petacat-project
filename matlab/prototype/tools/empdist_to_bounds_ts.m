




% generate empirical distribution
    x = zeros( 300,500 );
    
    x( 100,100 ) = 1;
    x( 120,150 ) = 1;
    
    x( 200,300 ) = 1;
    x( 250,300 ) = 1;
    
    h = blackman(100)*blackman(100)';
    x = filtern(h,x);
    x = mat2gray(x);
    
% sample from and model the empirical distribution
    k = 2;
    [mu,Sigma] = empdist_to_gmm( x, k );
    
% define bounding boxes
    coords = box_gmm( mu, Sigma );
    
% view boxes on the empirical distribution
    figure;
    imshow( x, [] );
    hold on;
    for bi = 1:size(coords,1);
        draw_box_mq(coords(bi,:));
    end
    hold off;

    
    
    
    
    
    