


file_list = dir('*example*');

fields = {'File name', 'Start Time:', 'A:', 'B:', 'C:', 'D:', 'T:'};
session_data = cell( length(file_list), length(fields) );



% read the session data

    for fi = 1:length(file_list)

        session_data{fi,1} = file_list(fi).name;

        fid = fopen( file_list(fi).name );
        tline = fgetl(fid);

        while ischar(tline)

            if length(tline) > 11 && strcmp(tline(1:11),fields{2})
                session_data{fi,2} = tline(13:end);
            end

            if length(tline) > 2
                switch tline(1:2)
                    case 'A:'
                        session_data{fi,3} = str2num(tline(3:end));
                    case 'B:'
                        session_data{fi,4} = str2num(tline(3:end));
                    case 'C:'
                        session_data{fi,5} = str2num(tline(3:end));
                    case 'D:'
                        session_data{fi,6} = str2num(tline(3:end));
                    case 'T:'
                        session_data{fi,7} = str2num(tline(3:end));
                    otherwise
                        % do nothing
                end
            end

            tline = fgetl(fid);
        end


        fclose(fid);

    end

    
    
% write to a csv

    fname = 'output.csv';
    fid = fopen(fname,'w'); % 'w' means it's a new file that we can write to

    % print the header line
        
        fprintf(fid,'%s , %s , %s , %s , %s , %s , %s \n', ...
            fields{1}, ...
            fields{2}, ...
            fields{3}, ...
            fields{4}, ...
            fields{5}, ...
            fields{6}, ...
            fields{7} );

    % print the rest of the data
    
        for li = 1:size(session_data,1)

            fprintf(fid,'%s , %s , %d , %d , %d , %d , %d \n', ...
                session_data{li,1}, ... 
                session_data{li,2}, ... 
                session_data{li,3}, ... 
                session_data{li,4}, ... 
                session_data{li,5}, ... 
                session_data{li,6}, ... 
                session_data{li,7} );

        end

    fclose(fid);



    