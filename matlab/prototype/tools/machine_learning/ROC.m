function [AUROC, TPR, FPR, thresholds] = ROC( d_vars, labels, direction )
    %
    % [AUROC, TPR, FPR, thresholds] = ROC( d_vars, labels, direction );
    %
    % if direction is (+), then a high d_val is associated with targets
    % if direction is (-), then a low d_val is associated with targets
    % if direction is (0), then ROC will make a charitable assumption
    
    
    
    ifndef('direction',0);
    if ifndef('d_vars',[])
        display('ROC in demo mode');
        d_vars = [ randn(100,1); randn(100,1)+2 ];
        labels = [ zeros(100,1);  ones(100,1) ];
        direction = 1;
    end
    
    
    
    d_tar_in = d_vars(eq(labels,1));
    d_non_in = d_vars(eq(labels,0));
    
    
    
    % set up our thresholds
    
        if direction == 0;
            if mean(d_tar_in) > mean(d_non_in)
                direction = 1;
            else
                direction = -1;
            end
        end

        d_tar = direction * d_tar_in(:)';
        d_non = direction * d_non_in(:)';

        steps = 100;
        d_min = min([ d_tar d_non ]);
        d_max = max([ d_tar d_non ]);
        range = d_max - d_min;
        
        thresholds = linspace( d_max + range/steps, d_min - range/steps, steps );

        
        
    % calculate TPR and FPR for each threshold
    
        TPR = zeros(1,steps);
        FPR = zeros(1,steps);
        for i = 1:steps
            cur_thresh = thresholds(i);
            TPs = sum( gt(d_tar, cur_thresh) );
            FPs = sum( gt(d_non, cur_thresh) );
            TPR(i) = TPs / length(d_tar);
            FPR(i) = FPs / length(d_non);
        end
    
        
        
    % calculate area under the ROC curve (average of left hand and right
    % hand AUROC)
    
        AUROC = ...
           mean([ 
                sum( TPR(1:end-1) .* abs((FPR(2:end) - FPR(1:end-1))) ), ...
                sum( TPR(2:end)   .* abs((FPR(2:end) - FPR(1:end-1)) )) ]);


            
end