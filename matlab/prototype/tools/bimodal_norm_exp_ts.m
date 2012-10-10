% bimodal_norm_exp_ts



% define the pdf as an anonymous function
%   or use an existing function and slap a @ on front of it

    bimodal_norm_exp_pdf = @(x,beta,mu,sigma,lambda) (beta).*normpdf(x,mu,sigma) + (1-beta).*exppdf(x,lambda);
    

    
% generate data from a distribution
%   in this case, a mix of values from a normal distribution and an exponential distribution
%   with a mixing factor beta

    beta   = .25;
    mu     = .30;
    sigma  = .10;
    lambda = .01;
    theta_target = [beta,mu,sigma,lambda];

    n = 500;

    y1 = rand(fix((1-beta)*n),1);
    x1 = expinv(y1,lambda);

    y2 = rand(fix(beta*n),1);
    x2 = norminv(y2,mu,sigma);

    x3 = [x1; x2];

    
    
% estimate parameters with MLE

    theta_0 = [.5, .5, .2, .02];
    theta_est = mle(x3, 'pdf', bimodal_norm_exp_pdf, 'start', theta_0);
    % theta_est = mle(x3, 'pdf', @bimodal_norm_exp_pdf, 'start', theta_0); % if the function isn't anonymous

    
    
    display(theta_0);
    display(theta_target);
    display(theta_est);

    beta_est   = theta_est(1);
    mu_est     = theta_est(2);
    sigma_est  = theta_est(3);
    lambda_est = theta_est(4);

    
    
% compare generating distribution with estimated distribution
   
    figure

    subplot(1,3,1)
    hist(x3,20);
    [h,c] = hist(x3,20);
    auh = ( sum( h(1:end-1).*diff(c) ) + sum( h(2:end).*diff(c) ) ) / 2;

    subplot(1,3,2)
    x_interp = linspace(min(x3),max(x3),1000);
    y_interp = bimodal_norm_exp_pdf(x_interp,beta_est,mu_est,sigma_est,lambda_est);
    plot(x_interp,y_interp);

    subplot(1,3,3)
    hold on
    hist(x3,20);
    plot( x_interp, auh * y_interp, 'r' );
    hold off;

