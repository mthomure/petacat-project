function fig_handle = petacat_visualize( image, box_source_map, box_coords, class_names, dvars )

    % petacat_visualize( image, box_source_map, box_coords, class_name, dvar );
    %
    % image,            an image matrix
    % box_source_map,   an image matrix
    % box_coords,   [x0 y0 xf yf] (1 row per crop)
    % class_names,  string or cellstring (1 class name per crop)
    % dvars,        1d numeric array (1 entry per crop)
    %
    % fig_handle for the generated figure is returned
    %
    % image -> box_source_map -> box_coords
    % class_name 
    % dvar = glimpse(image, box_coords, class_name)
   
    
    
    if ~exist('image','var') || isempty(image)
        display('petacat_visualize is in demo mode!!!');
        
        % fake image
        image = imread('lincoln2.jpg');
        image = rgb2gray(image);
        image = double(image)/255;

        % fake box_source_map
        m = 100;
        h = blackman(m)*blackman(m)';
        h = h / sum(h(:));
        box_source_map = filtern( h, image );

        % fake box
        r0 = round( size(image,1) * .25 );
        c0 = round( size(image,2) * .25 );
        rf = round( size(image,1) * .75 );
        cf = round( size(image,2) * .75 );
        box_coords = [c0 r0 cf rf];
        box_coords(2,:) = box_coords(1,:) + 50;

        % fake class
        class_names{1} = 'person';
        class_names{2} = 'dog';

        % fake score
        dvars = [2.5 -1];
        
    end
    
    
    fig_handle = figure( ...
        'OuterPosition',[100 100 1000 500],...
        'Name','petacat visualizer');
   
    subplot(1,2,1); 
    imshow(image,[]);
    hold on; 
    for bi = 1:size(box_coords,1)
        draw_box( box_coords(bi,:) );
        
        if iscellstr( class_names ), cur_class_name = class_names{bi};
        else cur_class_name = class_names; end
        
        text(...
            box_coords(bi,1), box_coords(bi,2),...
            sprintf('class: %s? dvar: %0.3g', cur_class_name, dvars(bi) ),...
            'EdgeColor',[0 0 1],...
            'BackgroundColor',[.4 .4 .4],...
            'Color',[0 0 0] );
        
    end
    hold off;
    title('image');
    
    subplot(1,2,2); 
    imshow(box_source_map,[]);
    hold on;
    draw_box( box_coords );
    hold off;
    title('bounding box source');
    
    
    
end
    
    







    
function [] = draw_box(x, arg)

    % draw_box(x, arg)
    % x = [x0 y0 xf yf]
    % or 
    % x = [c0 r0 cf rf]
    %
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
    
    