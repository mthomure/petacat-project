


function area = rectint_coords(A,B)

% AREA = RECTINT_COORDS(A,B) returns the area of intersection of the
% rectangles specified by coordinate vectors A and B.  
% 
% If A and B each specify one rectangle, the output AREA is a scalar.
% 
% A and B can also be matrices, where each row is a position vector.
% AREA is then a matrix giving the intersection of all rectangles
% specified by A with all the rectangles specified by B.  That is, if A
% is M-by-4 and B is N-by-4, then AREA is an M-by-N matrix where
% AREA(P,Q) is the intersection area of the rectangles specified by the
% Pth row of A and the Qth row of B.
% 
% Note:  A coordinate vector is a four-element vector [X1,Y1,X2,Y2],
% where the point defined by X1 and Y1 specifies one corner of the
% rectangle, and X2 and Y2 define the the opposite corner.

    area = rectint(rect_coords2position(A),rect_coords2position(B));
    
end





function position = rect_coords2position(coords)
    
    % give x1,y1, x2,y2 
    % get  x1,y1, w,h

    position = [ coords(:,1) ...
                 coords(:,2) ...
                 coords(:,3) - coords(:,1) ...
                 coords(:,4) - coords(:,2) ];
    
end








