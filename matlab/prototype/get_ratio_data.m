function ratios = get_ratio_data( directories )

    if ~exist('directories','var') || isempty(directories)

        % source directories
        directories{1} = '/Users/Max/Desktop/Petacat work/images/dog-other/';
        directories{2} = '/Users/Max/Desktop/Petacat work/images/dog-walking/';
        directories{3} = '/Users/Max/Desktop/Petacat work/images/dog-walking-from-web/';
        directories{4} = '/Users/Max/Desktop/Petacat work/images/people-other/';
        
    end
    
    d = get_image_info( directories );

    % distractor directory
        distractor_path = '/Users/Max/Desktop/Petacat work/images/other/';
        distractor_files = dir([distractor_path '*.jpg']);



    % % source directories
    %     directories{1} = '/Users/mm/Desktop/images/dog-other/';
    %     directories{2} = '/Users/mm/Desktop/images/dog-walking/';
    %     directories{3} = '/Users/mm/Desktop/images/dog-walking-from-web/';
    %     directories{4} = '/Users/mm/Desktop/images/people-other/';
    %     d = get_image_info( directories );
    % 
    % % distractor directory
    %     distractor_path = '/Users/mm/Desktop/images/other/';
    %     distractor_files = dir([distractor_path '*.jpg']);






    %% get per-category aspect ratios
    % and area ratios

        aspect_ratio = [];
        area_ratio   = [];
        category = {};
        for fi = 1:length(d)
            aspect_ratio = [aspect_ratio d(fi).rect_aspect];
            area_ratio = [area_ratio d(fi).area_ratio];
            category = [category d(fi).label];
        end
        categories = unique(category);
        inds_dog = ...
            logical( ...
            strcmp(category,'dog back')    + ... 
            strcmp(category,'dog front')   + ...
            strcmp(category,'dog my_left') + ...
            strcmp(category,'dog my_right') );
        inds_human = ...
            logical( ...
            strcmp(category,'pedestrian back')    + ... 
            strcmp(category,'pedestrian front')   + ...
            strcmp(category,'pedestrian my_left') + ...
            strcmp(category,'pedestrian my_right') );
        inds_leash = ...
            logical( ...
            strcmp(category,'leash-/') + ... 
            strcmp(category,'leash-\') );

        ratios.aspect_dog   = aspect_ratio( inds_dog );
        ratios.aspect_human = aspect_ratio( inds_human );
        ratios.aspect_leash = aspect_ratio( inds_leash );

        ratios.area_dog   = area_ratio( inds_dog );
        ratios.area_human = area_ratio( inds_human );
        ratios.area_leash = area_ratio( inds_leash );
        
end
        
        
        
        



function d = get_image_info( directories )

    % d = get_image_info( directories );
    %
    % pulls out sizes of bounding boxes from label files in the directories
    % provided
    %
    % label format:
    %
    % img-width|image-height|num-rects|x0|y0|w0|h0|x1|y1|w1|h1|label0|label1


    if ~exist('directories','var') || isempty(directories)

        directories{1} = '/Users/Max/Desktop/Petacat work/images/dog-other/';
        directories{2} = '/Users/Max/Desktop/Petacat work/images/dog-walking/';
        directories{3} = '/Users/Max/Desktop/Petacat work/images/dog-walking-from-web/';
        directories{4} = '/Users/Max/Desktop/Petacat work/images/people-other/';
        
    end

    
    
    k = 1;
    for di = 1:length(directories)
        files = dir([ directories{di} '*.labl' ]);
        for fi = 1:size(files)
            fnames{k} = [directories{di} files(fi).name];
            k = k + 1;
        end
    end
    
    for fi = 1:length(fnames)

        d(fi).fname = [ fnames{fi}(1:end-4) 'jpg' ];
        
        if ~exist(d(fi).fname,'file')
            delete( fnames{fi} );
        else

            fid = fopen( fnames{fi} );
            specification_string = fgetl(fid);
            spec = split( specification_string, '|' );
            fclose(fid);

            d(fi).im_width  = str2num( spec{1} );
            d(fi).im_height = str2num( spec{2} );
            d(fi).num_rects = str2num( spec{3} );

            si = 4;
            for ri = 1:d(fi).num_rects
                x = str2num( spec{si} );
                y = str2num( spec{si+1} );
                w = str2num( spec{si+2} );
                h = str2num( spec{si+3} );
                d(fi).rect{ri} = [x y w h];
                si = si + 4;

                d(fi).rect_aspect(ri) = d(fi).rect{ri}(4) / d(fi).rect{ri}(3);
                d(fi).area_ratio(ri) = (w*h) / (d(fi).im_width*d(fi).im_height);
            end

            for ri = 1:d(fi).num_rects
                d(fi).label{ri} = spec{si};
                si = si+1;
            end
            
        end


    end
   
    
end








function [result] = split( s, d )

% [result] = split( s, d );
%
% s is a string
% d is a delimiter (or list of delimiters)
%   if not specified, any white space is used
%
% result is a cell array of the parsed strings
%
% example:
%   result = split( 'hello|stupid world', {'|',' '} );


    if ~exist('d','var') || isempty( d )
       
        % use the default delimiter behavior (any whitespace)
        
        % grab the initial token
            [token,remainder] = strtok(s);
            result{1} = token;

        % loop while there are tokens left to grab
            i = 2;
            while(remainder)
                [token,remainder] = strtok(remainder);
                result{i} = token;
                i = i + 1;
            end
        
        
    else
        
         % use all of the delimiters in d
         
        [token,remainder] = strtok(s,d);
        result{1} = token;

        i = 2;
        while(remainder)
            [token,remainder] = strtok(remainder,d);
            result{i} = token;
            i = i + 1;
        end
        
    end
    
end



   
   
   
   
   
   
   
        