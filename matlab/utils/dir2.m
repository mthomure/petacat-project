function cleaned_file_list = dir2( path )
% file_list = dir2( path )
%
% Returns the contents of the directory 'path', removing hidden files (in
% Mac OSX, these are the files starting with a period.)



%% Read all files in the specified path.

file_list         = dir( path );
cleaned_file_list = file_list; % this list will get 'cleaned' 
                               % by removing hidden files
                               
num_files         = numel( file_list );





%% Remove hidden files.
%
%  Work from the end of the list to the front, so that deleting entries
%  doesn't throw off our indexing.

indices = fliplr( 1 : num_files ); % [num_files, num_files - 1 ,..., 2 , 1]

for i = indices
    
    
    
    
   %% on OSX, hidden files start with a period.
   %
   %  If the first character of the file name is a period, then flag this
   %  as a 'hidden file.'
   
   if strcmp( file_list(i).name(1) , '.' )
       cleaned_file_list(i) = [];
   end
   
   
   
   
   
   
end






