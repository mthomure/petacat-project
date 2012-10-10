


    % training data
        x = [randn(50,2); randn(50,2) + 1];
        y = [zeros(50,1); ones(50,1)];

    % testing data
        xt = [randn(50,2); randn(50,2) + 1];
        yt = [zeros(50,1); ones(50,1)];
    
        
        
    % train the model
    %   The RBF kernel (-t 2) is selected, with its Gamma parameter
    %   to 0.3 (-g 0.3) and an error penalization parameter set to 0.5,
    %   (-c 0.5).  (See Example Session for details).
    
        model = svmlearn(x,y,'-t 2 -g 0.3 -c 0.5');

        % note
        % 	This produces the following output to the command window, and a
        % 	new MATLAB variable, "model" is created.  This is a structure that
        % 	contains the support vectors, and values computed by the optimization
        % 	procedures (e.g. alpha values, model_length, ...).
        % 
        % 	Note: Adding a '-v 0' to the parameter string disables output
        % 	from the SVM software.

    
    
    % classify the testing data

        [err, predictions] = svmclassify(xt,yt,model);

        % note
        %   It is safe to ignore the warning about "lin_weights".	
        % 
        % 	An example session follows.  It demonstrates training a 
        % 	SVM with the parameters described above.  The error rate
        % 	of the testing (using the learned model) is displayed at 
        % 	the end (as a percentage).


