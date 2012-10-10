

clear all; close all; clc;


% define some clusters
    num_points = 100;

    c1_x = 15 + 5 * randn(num_points,1);
    c1_y =  6 + 1 * randn(num_points,1);

    c2_x =  0 + 5 * randn(num_points,1);
    c2_y =  0 + 1 * randn(num_points,1);
    
    c_x = [c1_x; c2_x];
    c_y = [c1_y; c2_y];
    
    
    
% see what the clusters look like before any alteration
    figure('name', 'pre pca clusters');
    
    subplot(2,3,1);
    title('data');
    hold on
    plot( c_x(1:num_points), c_y(1:num_points), '.b' );
    plot( c_x(num_points+1:end), c_y(num_points+1:end), '.r' );
    % force a square coordinate system
        axis([...
            min([c_x; c_y])...
            max([c_x; c_y])...
            min([c_x; c_y])...
            max([c_x; c_y]) ]);
    hold off;
    
% see what the clusters look like projected onto the individual axes
    subplot(2,3,2);
    title('feature 1 projection');
    hist(c_x)
    
    subplot(2,3,3);
    title('feature 2 projection');
    hist(c_y)
    
    
    
% apply PCA
    [coeff,c_transformed] = princomp([c_x c_y]);
    ct_x = c_transformed(:,1);
    ct_y = c_transformed(:,2);
    
    % for reference
    %   if you'd like to learn the pca transform from one data set and apply 
    %   it to another: 
    
    % c_transformed = [c_x - mean(c_x) c_y - mean(c_y)] * coeff;
    
    
    
    
% see what the clusters look like after PCA
    subplot(2,3,4)
    title('post pca clusters');
    hold on
    plot( ct_x(1:num_points),     ct_y(1:num_points),     '.b' );
    plot( ct_x(num_points+1:end), ct_y(num_points+1:end), '.r' );
    % force a square coordinate system
        axis([...
            min(min(c_transformed))...
            max(max(c_transformed))...
            min(min(c_transformed))...
            max(max(c_transformed)) ]);
    hold off

% look at the projections on the PCA axes
    subplot(2,3,5);
    hist(ct_x)
    
    subplot(2,3,6);
    hist(ct_y)
