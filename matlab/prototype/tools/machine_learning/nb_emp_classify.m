function Posterior_numerator = nb_emp_classify( x, pdf_center, pdf_freq, class_p )

    clear all; close all; clc;
    
    d = load('dpsd_s3_26-Mar-2012');
    x = d.psdr_r;
    x = shiftdim(x,2);
    x = reshape(x,size(x,1),[]);
    y = d.x_label_instances;
    clear d;
    
    [ pdf_center, pdf_freq, class_p, class ] = nb_emp_learn( x, y );
    
    
    
    
    
    
    
    
    
    % % nb = NaiveBayes.fit(x,y,'Distribution','kernel');
    % % post = posterior(nb,x);
    
    

    % P(c|x) = P(x|c) * P(c) / P(x);
    
    
    % for each instance of x, need to find its nearest bin center and give it a probability.
     
    abs( squeeze( pdf_center(1,1,:) ) - x(1,1) )
        
    
    
    
end
    





