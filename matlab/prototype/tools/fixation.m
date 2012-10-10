function [fixations_points] = fixation( im, ih_s, num_fixations, verbose, inhibition_mode )
    % im            - image
    % ih_s          - inhibition size
    % num_fixations - number of fixations
    % verbose       - display results (true/false)

    
    ifndef('inhibition_mode','disk'); % 'blackman' or 'disk'
    
    if ifndef('im', .25*rand(100) ); 
        im(20,20) = 1; 
        im(50,50) = .75; 
        verbose = true; 
        display('fixation in demo mode'); 
    end
    
    if strcmp(inhibition_mode,'blackman')
        ifndef('ih_s', fix(.4 * max(size(im))) );
    elseif strcmp(inhibition_mode,'disk')
        ifndef('ih_s', fix(.1 * max(size(im))) );
    end

    ifndef('num_fixations',5);
    ifndef('verbose',false);
    
    
    
    im = mat2gray(im); % if vals are all under 0, then the inhibition is actually increasing the salience
    
    
    
    % generate inhibition map, pad array
    
        if strcmp(inhibition_mode,'blackman'), ih = 1 - max( 0, blackman(ih_s) * blackman(ih_s)' ); end
        if strcmp(inhibition_mode,'disk'),     ih = 1 - disk(ih_s); end
        
        
        pad_size = ih_s;
        im_p = padarray(im, [pad_size,pad_size] );

        
        
    fixations_points = zeros(num_fixations,2);

    
    
    for i = 1:num_fixations

        % fixate
            [rc, cc] = find( ...
                        reshape( ...
                            eq( im_p(:), max(im_p(:)) ), ...
                            size(im_p,1),...
                            size(im_p,2)));

            fixations_points(i,:) = [rc(1), cc(1)];
        
        % inhibit return
            ihr0 = max( fix( rc - ih_s / 2), 1 );
            ihrf = min( ihr0 + ih_s - 1, size(im_p,1) );
            ihc0 = max( fix( cc - ih_s / 2), 1 );
            ihcf = min( ihc0 + ih_s - 1, size(im_p,2) );

            im_p(ihr0:ihrf,ihc0:ihcf) = im_p(ihr0:ihrf,ihc0:ihcf) .* ih;
            
    end

    
    
    fixations_points = fixations_points - pad_size;
    

    
    if verbose

        % unpad
            r0 = pad_size  + 1;
            rf = r0 + size(im,1) - 1;
            c0 = pad_size  + 1;
            cf = c0 + size(im,2) - 1;
            im_unpad = im_p(r0:rf,c0:cf,:);
        
        imshow( im_unpad, [] );
        
        hold on;
        plot( fixations_points(:,2), fixations_points(:,1), 'r.-' );
        plot( fixations_points(1,2), fixations_points(1,1), '.b' );
        hold off;
        
    end
    

    
    
end







function wasnt_given = ifndef( var_name, default_value )
%
% wasnt_given = ifndef( var_name, default_value );
%
%   if the variable isn't defined (wasn't passed in, was passed in empty)
%
%   then create the variable and assign it the value in default_value (in the
%   calling namespace)
%
%   wasn't given is a boolean indicating whether anything was assigned
    
    call_to_check_var = ['( ~exist(''' var_name ''',''var'') || isempty(' var_name '));'];
    wasnt_given = evalin( 'caller', call_to_check_var );
    
    if wasnt_given; 
        assignin( 'caller', var_name, default_value ); 
    end;
    
end
