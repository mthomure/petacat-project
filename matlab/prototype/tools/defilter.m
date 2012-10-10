function x = defilter(y, h)

    [r,c] = size(h);
    yp = padarray(y,[r c],0);
    
    x = zeros(size(yp,1),size(yp,2),size(h,3));
    
    for i = r+1:r+1+size(y,1)
        for j = c+1:c+1+size(y,2)
            
            r0 = fix(i-r/2);
            rf = r0 + r - 1;
            c0 = fix(j-c/2);
            cf = c0 + c - 1;
            
            x(r0:rf,c0:cf) = x(r0:rf,c0:cf) + yp(i,j) * h;
            
        end
    end
    
    r0 = r+1;
    rf = r0+size(y,1)-1;
    c0 = c+1;
    cf = c0+size(y,2)-1;
    x = x(r0:rf,c0:cf);
    
end
    
            
    