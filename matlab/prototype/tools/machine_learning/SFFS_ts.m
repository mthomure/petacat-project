


% SFFS algorithm test script
% sequential floating forward selection



clear all;
close all;
clc;



% set some feature quality statistics

    n = 1000;
    m = 5;

    mu = [ 0 * ones(m,1)     linspace(1,0,m)' ];
    
    sigma = [ 1 * ones(m,1)     1 * ones(m,1)    ];
    dprime_dist = mu(:,2)' - mu(:,1)';
    
   
    
% generate independent features for n instances

    class = [ true(fix(n/2),1); false(fix(n/2),1) ];

    for i = 1:length(class)

        if class(i) == 1
            x(i,:) = (sigma(:,1)') .* randn(1,m) + mu(:,1)';
        end

        if class(i) == 0
            x(i,:) = (sigma(:,2)') .* randn(1,m) + mu(:,2)';
        end

    end
    
    dprime_samp = mean(x(~class,:)) - mean(x(class,:));
    


% SFFS algorithm

   [ selected, AUROCs ] = SFFS( x, class );
    
   
    
% display the results

    display(dprime_dist);
    display(dprime_samp);
    display(selected);
    display(AUROCs);


            
         




