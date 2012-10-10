function  [ pdf_center, pdf_freq, class_p, class, Posterior_numerator ] = nb_emp_learn( x, y )



    class = unique(y);
    
    n = size(x,1);
    m = size(x,2);
    c = length(class);
    
    bins = round( sqrt(n/c) );
    
    
    
    for ci = 1:c
        
        class_p(ci) = mean( eq( class(ci), y ) );

        for mi = 1:m

            [pdf_freq(ci,mi,:), pdf_center(ci,mi,:)] = hist( x(eq(y,class(ci)),mi), bins );
            
        end
        
    end

    
    
    if nargout > 4
        Posterior_numerator = nb_emp_classify( x, pdf_center, pdf_freq, class_p );
    end
    
    
    
end
    
    
   
    
    
    
    