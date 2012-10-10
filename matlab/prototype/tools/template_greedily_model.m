function [ model, coeffs, variance_total ] = template_greedily_model( x, h, n )



    % [ model, coeffs, variance_total ] = greedily_model( x, h, n )
    % account for as much variance as possible in each of n iterations (3?)
    % covariance between the signal x with the patterns in h
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

    
    
    verbose = false;
    
    k = size( h, 1 );
    m = size( h, 2 );
    
    x = padarray( x, [0 m] );
    
    coeffs = zeros(k,length(x));
    
    residual_cur = x;
    
    
    
    variance_total = zeros(1,n+1);
    variance_total(1) = var(x);
    for iteration = 1:n
        
        cov_w = zeros(k,length(x));
        for hi = 1:k
            [~,cov_w(hi,:)] = corr_windowed( h(hi,:), residual_cur );
        end
        
        % find covariance peaks
            if k > 1
                [cov_w,h_best] = max(cov_w);
            else
                h_best = ones(size(cov_w));
            end
            
            cov_local_max = local_max_vect(cov_w,2*m);
            
            %cov_threshold  = mean(cov_w) + 2*std(cov_w);
            qrs = prctile(cov_w,[25 75]);
            iqr = max(qrs)-min(qrs);
            cov_threshold = max(qrs)+3*iqr;
            
            cov_peaks = and( eq(cov_local_max,cov_w), gt(cov_w,cov_threshold) );
            cov_peak_inds = find(cov_peaks);
            
            if verbose
                figure
                hold on;
                plot(cov_w,'b');
                plot(cov_local_max,'g');
                plot([1,length(cov_w)],[cov_threshold cov_threshold],'g--');
                plot(find(cov_peaks),cov_w(cov_peaks),'.r')
                legend('covariance','threshold','peaks');
            end
            
        % for each peak, figure out coefficients
        
            t0s = cov_peak_inds - fix(m/2);
            tfs = t0s + m - 1;
            
            tfs( lt(t0s,1) ) = [];
            cov_peak_inds(lt(t0s,1)) = [];
            t0s( lt(t0s,1) ) = [];
            
            t0s( gt(tfs,length(x)) ) = [];
            cov_peak_inds(gt(tfs,length(x))) = [];
            tfs( gt(tfs,length(x)) ) = [];
            
% display(length(cov_peak_inds));
        
            for pi = 1:length(cov_peak_inds)
                
                cur_ind = cov_peak_inds(pi);
                cur_h = h_best(cur_ind);
            
                % grab the segment and pattern
                    t0 = cur_ind - fix(m/2);
                    tf = t0 + m - 1;
                    segment = x(t0:tf);
                    pattern = h(h_best(cur_ind),:);

                % fit the pattern
                    error = @(a)( sum( ( a*pattern - segment ).^2 ) );
                    af = fminsearch(error,0);

                    coeffs(cur_h,cur_ind) = af;
              
            end
            
        % model and update the residual

            model = zeros(size(x));
            for i = 1:size(coeffs,1);

                model = model + conv( coeffs(i,:), h(i,:), 'same' );

            end

            residual_cur = x - model;
        
            variance_total(n+1) = var(residual_cur);
        
    end
    
    
    
    
    model = zeros(size(x));
    for i = 1:size(coeffs,1);

        model = model + conv( coeffs(i,:), h(i,:), 'same' );

    end

    % unpad the return values
    model = model(m+1:end-m);
    coeffs = coeffs(:,m+1:end-m);
    
    
end