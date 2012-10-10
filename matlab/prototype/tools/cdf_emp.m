function [y,p] = cdf_emp( x, n )

% [y,p] = cdf_emp( x, n );
% 
% x is the data
% n is the number of percentiles to use (defaults to 20)
%
% get values at regular percentiles from 0 to 100
% y has the values
% p has the percentiles

    if ~exist('n','var') || isempty(n)
        n = 20;
    end
    
    p = linspace(0,100,n)';
    y = prctile( x(:), p );
    p = p / 100;
    
end


