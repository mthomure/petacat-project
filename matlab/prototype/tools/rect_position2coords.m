


function coords = rect_position2coords(position)

    % give x1,y1, w,h
    % get  x1,y1, x2,y2 
    
    coords = [ position(:,1) ...
               position(:,2) ...
               position(:,1) + position(:,3) ...
               position(:,2) + position(:,4) ];
            
end

