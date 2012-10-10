

function [] = rect_draw_position(x,arg)

    % rect_draw_position(x,'arg')
    %
    % x,y,w,h
    % or 
    % col,row,cols,rows

    for i = 1:size(x,1)
        
        rs = [x(i,1) x(i,1) x(i,1)+x(i,3) x(i,1)+x(i,3) x(i,1)];
        cs = [x(i,2) x(i,2)+x(i,4) x(i,2)+x(i,4) x(i,2) x(i,2)];
        
        if ~exist('arg','var')
            plot(rs,cs);
        else
            plot(rs, cs, arg);
        end
        
    end
    
end