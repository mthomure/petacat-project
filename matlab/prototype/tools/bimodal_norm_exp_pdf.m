    

function [y] = bimodal_norm_exp_pdf(x,beta,mu,sigma,lambda)

    y = (beta).*normpdf(x,mu,sigma) + (1-beta).*exppdf(x,lambda);
    
end