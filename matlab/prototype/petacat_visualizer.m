


    classdef petacat_visualizer < handle
        
        % pv = petacat_visualizer(image,roi_map,boxes_roi,model_names,dvars);
        % pv.update_from_input()
        
        properties
            
            image           = [];
            roi_map         = [];
            boxes_roi       = [];   % boxes based on region of interest
            bi              = 1;    % box index
            class_ind       = 0;
            model_names     = [];
            dvars           = [];
            
            temp_point      = [];
            
            fig_handle      = [];
            boxes_backup    = [];
            
        end
        
        
        
        methods
            
            function pv = petacat_visualizer(image,roi_map,boxes_roi,model_names,dvars)
                
                pv.image        = image;
                pv.roi_map      = roi_map;
                pv.boxes_roi    = boxes_roi;
                pv.model_names  = model_names;
                pv.dvars        = dvars;
                pv.class_ind = 0;
                
                pv.boxes_backup = pv.boxes_roi;
                
            end
            
            function redraw(pv)

                if isempty(pv.fig_handle)
                    pv.fig_handle = figure( ...
                    'OuterPosition',[100 100 1000 500],...
                    'Name','Petacat Visualizer');
                else
                    figure(pv.fig_handle);
                end

                subplot(1,2,1)

                    imshow( pv.image, [] )
                    title('pv.image');
                    hold on;

                    if ~isempty( pv.temp_point )
                        plot(pv.temp_point(1),pv.temp_point(2),'or');
                    else

                        if ~isempty(pv.boxes_roi)

                            rect_draw_position( pv.boxes_roi(pv.bi,:), 'r');
                            text(...
                                pv.boxes_roi(pv.bi,1), pv.boxes_roi(pv.bi,2),...
                                sprintf('class: %s? pv.dvars(pv.bi): %0.3g', pv.model_names{pv.bi}, pv.dvars(pv.bi) ),...
                                'EdgeColor',[0 0 1],...
                                'BackgroundColor',[.4 .4 .4],...
                                'Color',[0 0 0] );

                        end
                    end

                    hold off;

                subplot(1,2,2)

                    imshow( pv.roi_map, [] );
                    title('salience');
                    hold on;

                    rect_draw_position( pv.boxes_roi,'b' );
                    
                    if ~isempty( pv.temp_point )
                        plot(pv.temp_point(1),pv.temp_point(2),'or');
                    else

                        if ~isempty(pv.boxes_roi)

                            rect_draw_position( pv.boxes_roi(pv.bi,:), 'r');
                            text(...
                                pv.boxes_roi(pv.bi,1), pv.boxes_roi(pv.bi,2),...
                                sprintf('class: %s? dvar: %0.3g', pv.model_names{pv.bi}, pv.dvars(pv.bi) ),...
                                'EdgeColor',[0 0 1],...
                                'BackgroundColor',[.4 .4 .4],...
                                'Color',[0 0 0] );

                        end

                    end

                    hold off;


                    
            end

            function pv = update_from_input(pv)
                
                key_mark   = 1;     % left click
                key_delete = 8;     % delete
                key_prev   = 28;    % <-
                key_next   = 29;    % ->
                key_reset  = 114;   % 'r'
                
                key_reclass = 30;   % up arrow
                
                key_end    = 27;    % esc
                
                class_options = {'dogs', 'pedestrians', 'leashes'};
                
                pv.redraw();
                
                [x,y,input_key] = ginput(1);
                
                while input_key ~= key_end

                    if input_key == key_mark   
                        pv.temp_point = [x y];
                        pv.redraw();
                        [x,y,input_key] = ginput(1);

                        pv.boxes_roi(end+1,:) = [pv.temp_point(1) pv.temp_point(2) x y];
                        pv.temp_point = [];
                        pv.bi = size(pv.boxes_roi,1);

                        % pull new crop
                            r0 = round( pv.boxes_roi(pv.bi,2) );
                            rf = r0 + round( pv.boxes_roi(pv.bi,4) ) - 1;
                            c0 = round( pv.boxes_roi(pv.bi,1) );
                            cf = c0 + round( pv.boxes_roi(pv.bi,3) ) - 1;

                            r0 = max(r0,1);
                            rf = min(rf,size(pv.image,1));
                            c0 = max(c0,1);
                            cf = min(cf,size(pv.image,2));

                            cur_crop = pv.image( r0:rf, c0:cf );

                        % get new dvar
                            pv.class_ind = randi(3,1,1);
                            pv.model_names(pv.bi) = class_options( pv.class_ind );
                            pv.dvars(pv.bi) = apply_glimpse_model( pv.model_names{pv.bi}, cur_crop );
                    end

                    if input_key == key_delete 

                        if ~isempty(pv.boxes_roi)
                            pv.boxes_roi(pv.bi,:) = [];
                            pv.model_names(pv.bi) = [];
                            pv.dvars(pv.bi) = [];
                        end

                        input_key = key_prev;
                    end

                    if input_key == key_prev   
                        pv.bi = pv.bi - 1;
                        if pv.bi < 1
                            pv.bi = size(pv.boxes_roi,1);
                            if pv.bi == 0, pv.bi = 1; end
                        end
                    end

                    if input_key == key_next   
                        pv.bi = pv.bi + 1;
                        if pv.bi > size(pv.boxes_roi,1)
                            pv.bi = 1;
                        end
                    end
                    
                    if input_key == key_reclass
                        % re-pull the current crop
                            r0 = round( pv.boxes_roi(pv.bi,2) );
                            rf = r0 + round( pv.boxes_roi(pv.bi,4) ) - 1;
                            c0 = round( pv.boxes_roi(pv.bi,1) );
                            cf = c0 + round( pv.boxes_roi(pv.bi,3) ) - 1;

                            r0 = max(r0,1);
                            rf = min(rf,size(pv.image,1));
                            c0 = max(c0,1);
                            cf = min(cf,size(pv.image,2));

                            cur_crop = pv.image( r0:rf, c0:cf );

                        % get new dvar
                            pv.class_ind = pv.class_ind + 1;
                            if pv.class_ind > 3, pv.class_ind = 1; end
                            pv.model_names(pv.bi) = class_options( pv.class_ind );
                            pv.dvars(pv.bi) = apply_glimpse_model( pv.model_names{pv.bi}, cur_crop );
                    end
                      
                    if input_key == key_reset  
                        pv.boxes_roi = pv.boxes_backup;
                        k = size(pv.boxes_roi,1);
                        % recrop
                        crops = cell(1,k);
                        for ci = 1:k
                            r0 = round( pv.boxes_roi(ci,2) );
                            rf = round( pv.boxes_roi(ci,4) );
                            c0 = round( pv.boxes_roi(ci,1) );
                            cf = round( pv.boxes_roi(ci,3) );

                            r0 = max(r0,1);
                            rf = min(rf,size(pv.image,1));
                            c0 = max(c0,1);
                            cf = min(cf,size(pv.image,2));

                            crops{ci} = pv.image( r0:rf, c0:cf );
                        end
                        % reclassify
                        pv.model_names = class_options( randi(3,1,k) );
                        pv.dvars = zeros(1,k);
                        for ci = 1:k
                            pv.dvars(ci) = apply_glimpse_model( pv.model_names{ci}, crops{ci} );
                            fprintf('.')
                        end
                        fprintf('\n glimpse done \n');
                    end

                    pv.redraw();
                    
                    [x,y,input_key] = ginput(1);
                    
                end % input while loop

            end % update from input
            
        end % methods
        
    end % class def
            
            
           
    
    
    
    
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




