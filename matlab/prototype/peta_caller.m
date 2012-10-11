function pc = peta_caller(fname,method)

    
    pc = petacat_prototype_2(fname);
    pc.load_gt;

    max_dim = 500;
    pc.resize(max_dim);
    pc.generate_boxes(method);
    pc.classify;

    pc.calculate_intersection;
    pc.gather_results;

end



function results = iterated_caller()

    % add petacat prototype path
        % addpath /Users/Max/Dropbox/Projects/Petacat/prototype
        addpath /u/quinn/petacat-project/matlab/prototype
    % add glimpse matlab wrapper path
        % addpath /Users/Max/Dropbox/Projects/Petacat/petacat-project/matlab
        addpath /u/quinn/petacat-project/matlab/
    % add some tools (max's stuff)
        addpath /u/quinn/petacat-project/matlab/prototype/tools
    % add normalized cuts code
        addpath('/u/quinn/petacat-project/matlab/normalized cuts code');
    
%     for n = 1:20
%         fprintf('''/Users/Max/Documents/MATLAB/data/petacat_images/dog-walking-from-web/dog-walking-from-web%d.jpg''...\n',n);
%     end

%     fname_list = {...
%         '/Users/Max/Documents/MATLAB/data/petacat_images/dog-walking-from-web/dog-walking-from-web1.jpg'...
%         '/Users/Max/Documents/MATLAB/data/petacat_images/dog-walking-from-web/dog-walking-from-web2.jpg'...
%         '/Users/Max/Documents/MATLAB/data/petacat_images/dog-walking-from-web/dog-walking-from-web3.jpg'...
%         '/Users/Max/Documents/MATLAB/data/petacat_images/dog-walking-from-web/dog-walking-from-web4.jpg'...
%         '/Users/Max/Documents/MATLAB/data/petacat_images/dog-walking-from-web/dog-walking-from-web5.jpg'...
%     };

    fname_list = { ...
        '/u/quinn/mm-group/mm-group-images/dog-walking-test-images-DO-NOT-USE-FOR-TRAINING/dmh-dog-walking19.jpg' ...
        '/u/quinn/mm-group/mm-group-images/dog-walking-test-images-DO-NOT-USE-FOR-TRAINING/mdt-dog-walking12.jpg' ...
        '/u/quinn/mm-group/mm-group-images/dog-walking-test-images-DO-NOT-USE-FOR-TRAINING/mm-dog-walking10.jpg' ...
        '/u/quinn/mm-group/mm-group-images/dog-walking-test-images-DO-NOT-USE-FOR-TRAINING/mm-dog-walking20.jpg' ...
        '/u/quinn/mm-group/mm-group-images/dog-walking-test-images-DO-NOT-USE-FOR-TRAINING/mm-dog-walking30.jpg' ...
        '/u/quinn/mm-group/mm-group-images/dog-walking-test-images-DO-NOT-USE-FOR-TRAINING/mm-dog-walking40.jpg' ...
        '/u/quinn/mm-group/mm-group-images/dog-walking-test-images-DO-NOT-USE-FOR-TRAINING/mm-dog-walking50.jpg' ...
        '/u/quinn/mm-group/mm-group-images/dog-walking-test-images-DO-NOT-USE-FOR-TRAINING/mm-dog-walking60.jpg' ...
        '/u/quinn/mm-group/mm-group-images/dog-walking-test-images-DO-NOT-USE-FOR-TRAINING/mm-dog-walking75.jpg' ...
        '/u/quinn/mm-group/mm-group-images/dog-walking-test-images-DO-NOT-USE-FOR-TRAINING/mm-dog-walking90.jpg' ...
        '/u/quinn/mm-group/mm-group-images/dog-walking-test-images-DO-NOT-USE-FOR-TRAINING/mm-dog-walking107.jpg' ...
        '/u/quinn/mm-group/mm-group-images/dog-walking-test-images-DO-NOT-USE-FOR-TRAINING/mm-dog-walking109.jpg' ...
        '/u/quinn/mm-group/mm-group-images/dog-walking-test-images-DO-NOT-USE-FOR-TRAINING/mm-dog-walking192.jpg' ...
        '/u/quinn/mm-group/mm-group-images/dog-walking-test-images-DO-NOT-USE-FOR-TRAINING/mm-dog-walking204.jpg' ...
    };
    
    method_options = {'random','salience','segmentation'};
    
    results = cell(3,1);
    for fi = 1:length(fname_list)
    for mi = 1:length(method_options)
    % for fi = 1
    % for mi = 2
        
        tic;
        % if exist('pc','var'), clear pc; end
        
        % select file and method
            fname = fname_list{fi};
            method = method_options{mi};
        
        % run petacat prototype
            pc = petacat_prototype_2(fname);
            pc.load_gt;

            max_dim = 500;
            pc.resize(max_dim);
            pc.generate_boxes(method);
            pc.classify;

            pc.calculate_intersection;
            pc.gather_results;

        % gather results
            intersection_data{fi,mi} = pc.intersection;
            results{mi} = [results{mi}; pc.results];
            save(sprintf('pc_f_%d_m_%s',fi,method),'pc');
            clear pc;

            fprintf('%.3f, %s, %s\n',toc,method,fname);
        
    end
    end
    
    display( method_options );
    display( [sort(results{1}(:)) sort(results{2}(:)) sort(results{3}(:))] );
    
    for i = 1:length(results)
        fprintf('%s\n',method_options{i});
        fprintf('  TP: %3d\n',sum(eq(results{i}(:),1)));
        fprintf('  FP: %3d\n',sum(eq(results{i}(:),2)));
        fprintf('  FN: %3d\n',sum(eq(results{i}(:),3)));
        fprintf('  TN: %3d\n',sum(eq(results{i}(:),4)));
        fprintf('\n\n');
    end
    
    save('2012.10.10_data.mat');
    
end
