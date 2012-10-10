


function position = rect_coords2position(coords)
    
    % give x1,y1, x2,y2 
    % get  x1,y1, w,h

    position = [ coords(:,1) ...
                 coords(:,2) ...
                 coords(:,3) - coords(:,1) ...
                 coords(:,4) - coords(:,2) ];
    
end







