function est = integral_est( x, y, a, b )
%
% est = integral_est( x, y, a, b );
%
% x is x
% y is y
%
% a is the start of the integral (x_0 value)
% b is the end   of the integral (x_f value)
%
% if a and b aren't given, then the start and end of x are used



    if ~exist('x','var') || isempty(x)
        display('integral_est didn''t get its args, so is in demo mode');
        y = sin(x);
        a = 0;
        b =  pi;
    else
        if ~exist('a','var') || isempty(a), a = x(1); end
        if ~exist('b','var') || isempty(b), b = x(end); end
    end
    
    
    
    a_ind = find(eq( min(abs(x-a)), abs(x-a) ),1);
    b_ind = find(eq( min(abs(x-b)), abs(x-b) ),1);

    x_interest = x( a_ind : b_ind );
    y_interest = y( a_ind : b_ind );

    est1 = dot( y_interest(1:end-1), diff(x_interest) );
    est2 = dot( y_interest(2:end),   diff(x_interest) );
    est  = mean([ est1 est2 ]);
    
end