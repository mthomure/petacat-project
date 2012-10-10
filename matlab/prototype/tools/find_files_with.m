function fnames = find_files_with( target_string, target_path )

    if nargin < 2; target_path = cd; end

    d = dir(target_path);
    has_target_string = false(length(d),1);
    fnames = cell(length(d),1);
    for i = 1:length(d)
        fnames{i} = d(i).name;
        ind = strfind( fnames{i}, target_string );
        if ind; has_target_string(i) = true; end;
    end
    fnames(~has_target_string) = [];
    
end