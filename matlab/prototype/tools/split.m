

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