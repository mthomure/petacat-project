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

    if strcmp(computer,'MACI64')
        % add petacat prototype path
        	addpath /Users/Max/Dropbox/Projects/Petacat/petacat-project/matlab/prototype
        % add glimpse matlab wrapper path
            addpath /Users/Max/Dropbox/Projects/Petacat/petacat-project/matlab
        % image path
            image_path = '/Users/Max/Dropbox/Projects/Petacat/dog-walking-test-images-DO-NOT-USE-FOR-TRAINING';
    else
        % add petacat prototype path
            addpath /u/quinn/petacat-project/matlab/prototype
        % add glimpse matlab wrapper path
            addpath /u/quinn/petacat-project/matlab/
        % add some tools (max's stuff)
            addpath /u/quinn/petacat-project/matlab/prototype/tools
        % add normalized cuts code
            addpath('/u/quinn/petacat-project/matlab/normalized cuts code');
        % image path
            image_path = '/u/quinn/mm-group/mm-group-images/dog-walking-test-images-DO-NOT-USE-FOR-TRAINING';
    end
    
    % get image names
        return_directory = pwd;
        cd(image_path);
        images_fn = dir('*.jpg');
        for fi = 1:length(images_fn)
            fname_list{fi} = sprintf('%s/%s\n',image_path,images_fn(fi).name);
        end
        cd(return_directory);
        clear return_directory;

    
    
    method_options = {'random','salience','segmentation'};
    
    results = cell(3,1);
    % for fi = 1:length(fname_list)
    % for mi = 1:length(method_options)
    for fi = 1
    for mi = 2
        
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
            %clear pc;

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
