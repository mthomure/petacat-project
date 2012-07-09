function [] = draw_box(x, arg)

    % draw_box(x, arg)
    % x = [r0 c0 rf cf]
    % arg is passed on to plot(x,y,arg)
    %
    % if x has multiple rows, they're each draw, but it relies on a figure
    % hold from outside of the function. that is, if you don't call 
    % 'hold on' before calling 'draw_box', you'll just get a box for the
    % last row of 'x'.

    
    
    for i = 1:size(x,1)

        rs = [x(i,1) x(i,1) x(i,3) x(i,3) x(i,1)];
        cs = [x(i,2) x(i,4) x(i,4) x(i,2) x(i,2)];

        if ~exist('arg','var')
            plot(rs,cs);
        else
            plot(rs, cs, arg);
        end
        
    end
    
    

end

