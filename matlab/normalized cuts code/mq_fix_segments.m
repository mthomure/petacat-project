

function segments_fixed = mq_fix_segments( segments )

    m = 3; 

    [fx fy] = gradient(segments);
    mask = filter2(ones(2*m,2*m),abs(fx)+abs(fy),'same');
    mask = 1-ne(mask,0);
    segments_fixed = mask .* segments;

end


        
        
        
        
        
        
        
        