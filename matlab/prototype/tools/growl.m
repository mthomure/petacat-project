function growl(message)

    % growl(message);

    % make it a string if it's not already
        if ~ischar(message)
            message = mat2str(message);
        end

    cmd = ['/usr/local/bin/growlnotify -m "' message '"'];
    system(cmd);
    fprintf('%s\n',message);
    
end