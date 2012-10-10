% princomp test script
    
    clear all;
    close all;
    clc;


% generate data

    n = 1000;
    tar_ratio = .25;
    n_tar = fix(tar_ratio*n);
    n_non = n - n_tar;

    data_tar = randn(n_tar,2) + repmat([3,3],n_tar,1);
    data_non = randn(n_non,2) + repmat([0,0],n_non,1);

    x = [data_tar; data_non];
        figure;
        plot( x(:,1), x(:,2), '.' );

        
        
% run princomp

    [coeff, score] = princomp(x);
        figure;
        plot(score(:,1), score(:,2), '.');

        
        
% check that we can reproduce it from coeff

    x_p = (x - repmat(mean(x),size(x,1),1)) * coeff;
        figure
        plot( x_p(:,1), x_p(:,2), '.' );





