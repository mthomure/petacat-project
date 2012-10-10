

function boxes_fixed = mq_boxes_adjust( b, r,c )

    m = 3;

    boxes_fixed = zeros(size(b));
    for i = 1:size(b,1)

        c0 = b(i,1);
        cf = c0 + b(i,3) - 1;
        r0 = b(i,2);
        rf = r0 + b(i,4) - 1;

        c0 = max(1,c0-m);
        r0 = max(1,r0-m);
        cf = min(c, cf+m);
        rf = min(r, rf+m);

        % display([c0 r0 cf rf]);

        boxes_fixed(i,:) = [c0,r0,cf-c0,rf-r0];
    end
    
end



        
        