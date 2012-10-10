

function a = histogram_difference( x1, x2 )

    % a = histogram_difference( x1, x2 );
    %
    % x1: dataset 1
    % x2: dataset 2
    %
    % a:  area between cdfs
    %
    % cdfs are calculated between 2nd and 98th percentiles
    % data is scaled to be unit variance (when combined)
    
    
    
    if ~exist('x1','var') || isempty(x1)
        x1 = randn(1000,1);
    end
    if ~exist('x2','var') || isempty(x2)
        x2 = sqrt(12) * (rand(1000,1)-.5);
    end
    
    var_combined = var( [x1(:); x2(:) ] );
    x1 = x1 / var_combined;
    x2 = x2 / var_combined;
    
    
    
    p = linspace( 2,98, 20 );
    
    cdf1 = prctile(x1,p);
    cdf2 = prctile(x2,p);
    
    area_diff = @(x,y1,y2) ...
        .5 * ( ...
            sum(abs(y2(1:end-1)-y1(1:end-1)) .* diff(x) ) ...
                + ...
            sum(abs(y2(2:end)-y1(2:end))     .* diff(x) ) );
        
    a = area_diff( p, cdf1, cdf2 );
    
end

























