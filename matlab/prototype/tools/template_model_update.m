
function [h_out, variance_total] = template_model_update( x, h, n )



    % [h_out, variance_total] = template_model_update( x, h )
    %
    % x is the signal
    % h are the templates
    % n is the number of modeling rounds ( try 3 )
    %
    %
    %
    % x = signal
    % m = template width (shoot for 2 * the width of the transient)
    % k = number of unique templates to use
    %
    % h = template_model_initialize( x, k, m );        
    % h = template_model_update(     x, h, 3 ); 
    % ...
    % h = template_model_update(     x, h, 3 );    
    % [signal_model,coeffs] = template_greedily_model( x, h, 3 ); 

    
    
    % select chip locations with local covariance

        k = size(h,1);
        m = size(h,2);

        if ~exist('n','var') || isempty(n)
            n = 3;
        end

        x = padarray(x,[0,m]);
        
        [ ~, coeffs, variance_total ] = template_greedily_model( x, h, n );
      
        
        
    % make new chips

        chips = zeros(length(find(coeffs(:))),m);
        ki = 1;
        for ci = 1:size(h,1)
            inds = find(coeffs(ci,:));
            for ti = 1:length(inds)
                cur_ind = inds(ti);

                coeffs_temp = coeffs;
                coeffs_temp(ci,cur_ind) = 0;

                model_temp = zeros(size(x));
                for i = 1:size(coeffs,1);
                    model_temp = model_temp + conv( coeffs_temp(i,:), h(i,:), 'same' );
                end
                residual_temp = x - model_temp;

                t0 = cur_ind - fix(size(h,2)/2);
                tf = t0 + size(h,2) - 1;
                temp_segment = residual_temp( t0:tf );
                temp_segment = temp_segment/std(temp_segment);
                chips(ki,:) = temp_segment;

                ki = ki + 1;

            end
        end



    % relearn the templates

        [~, h_out] = kmeans(chips, k);


        
        
end
    