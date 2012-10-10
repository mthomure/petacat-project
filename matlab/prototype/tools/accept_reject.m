function array_out = accept_reject( array_in, instructions, n )

    % array_out = accept_reject( array_in, instructions, n );

    if ~exist('instructions','var') || isempty(instructions)
        instructions = [];
    end
    
    if ~exist('n','var') || isempty(n)
        n = 1;
    end
    
    array_out = array_in;

    
    key_accept = 106;
    key_reject = 107;
    key_escape = 27; 
    
    
    i = 1;
    fig_handle = figure;
    while i <= length(array_out)
        
        for ni = 1:n*n
            subplot(n,n,ni);
            if (i + ni - 1) <= length(array_out)
                imshow( array_out{i + ni - 1} );
            else
                imshow( .5*ones(2) );
            end
        end
        
        title({instructions; 'accept (j), or reject (k)'});
        xlabel({['(' num2str(i) '-' num2str(min(i+n*n-1,length(array_out))) ') / ' num2str(length(array_out)) ],'(esc) to quit'});
        
        [x,y,button] = ginput(1);
        if button == key_accept
            i = i + n*n;
        elseif button == key_reject
            array_out(i:i+n*n-1) = [];
        elseif button == key_escape
            i = length(array_out);
        end
        
    end
    
    close(fig_handle);
   
end
   