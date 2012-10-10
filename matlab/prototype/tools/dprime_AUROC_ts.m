

% visualizing the relationship between d-prime and AUROC


dprimes = linspace( 0, 5, 100 );
m = 10000; % number of samples from a normal distribution
    

for di = 1:length(dprimes)
    
    dp_cur = dprimes(di);

    x1 = randn(m,1);
    x2 = dp_cur + randn(m,1);

    data = [x1; x2];
    labels = [zeros(m,1); ones(m,1)];

    [AUROC(di), TPR, FPR, thresholds] = ROC( data, labels );

end

figure;
plot(dprimes, AUROC)

xlabel('d-prime')
xlim([min(dprimes) max(dprimes)]);

ylabel('AUROC')
ylim([ .5 1.01 ]);




