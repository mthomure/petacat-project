function [h] = template_model_initialize( x, k, m )

    % x = signal
    % m = template width (shoot for 2 * the width of the transient)
    % k = number of unique templates to use
    %
    % h = template_model_initialize( x, k, m );        
    % h = template_model_update(     x, h, 3 ); 
    % ...
    % h = template_model_update(     x, h, 3 );    
    % [signal_model,coeffs] = template_greedily_model( x, h, 3 ); 


    x = padarray(x,[0,m]);

    % find peaks
        max_vals = local_max_vect(abs(x),round(m/4));
        threshold = mean(x) + 2*std(x);
        peaks = logical( eq(max_vals,abs(x)) .* gt(abs(x),threshold) );
        peak_inds = find(peaks);
        
% display(length(peak_inds));
        
    % clear out any that are in the padding for any reason
        peak_inds( peak_inds > (length(x)-m) ) = [];
        peak_inds( peak_inds < m ) = [];
        
    % make chips
        chips = zeros(length(peak_inds),m);
        for i = 1:length(peak_inds)
            t0 = round(peak_inds(i)-(m-1)/2);
            tf = round(peak_inds(i)+(m-1)/2);
            temp = x( t0:tf );
            temp = temp / std(temp);
            chips(i,:) = temp;
        end
        
    % cluster
        [~, h] = kmeans(chips, k);
        

verbose = false;
if verbose
    figure;
    for i = 1:10
        subplot(2,5,i);
        plot(chips(i,:))
    end
end
        
        
        
end


