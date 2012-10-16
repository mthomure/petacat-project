
function [] = add_new_boxes()

    fnames = dir('pc_*.mat');

    data_random         = [];
    data_salience       = [];
    data_segmentation   = [];
    
    for fi = 1:length(fnames)

        cur_fname = fnames(fi).name;
        d = load(cur_fname);
        new_boxes = make_new_boxes(d.pc);
        
        d.pc.roi_boxes(end+1:end+size(new_boxes,1),:) = new_boxes;
        d.pc.calculate_intersection;
        
        switch d.pc.roi_method
            case 'random'
                data_random = [data_random; max(d.pc.intersection,[],2)];
            case 'salience'
                data_salience = [data_salience; max(d.pc.intersection,[],2)];
            case 'segmentation'
                data_segmentation = [data_segmentation; max(d.pc.intersection,[],2)];
        end
         
    end
    
end





function new_boxes = make_new_boxes(pc)

    k = 1;
    for i = 1:size(pc.roi_boxes,1)
    for j = 1:i-1
        % fprintf('%d %d\n',i,j);
        new_boxes(k,:) = superbox( pc.roi_boxes(i,:), pc.roi_boxes(j,:) );
        k = k + 1;
    end
    end

end

function c = superbox( a, b )

    x0s = [a(1) b(1)];
    xfs = [a(1)+a(3) b(1)+b(3)];
    y0s = [a(2) b(2)];
    yfs = [a(2)+a(4) b(2)+b(4)];
    
    c(1) = min(x0s);
    c(3) = max(xfs) - c(1);
    
    c(2) = min(y0s);
    c(4) = max(yfs) - c(2);
    
end








