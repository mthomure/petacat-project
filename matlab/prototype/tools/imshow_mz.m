function h = imshow_mz(input)
    % imshow middle zero
    % h = imshow_mz(input);
    %
    % keeps 0 at middle gray, scales by the max(abs value)

    if nargout > 0
        h = imshow( input/(2*max(abs(input(:)))) + .5 );
    else
        imshow( input/(2*max(abs(input(:)))) + .5 );
    end
    
end