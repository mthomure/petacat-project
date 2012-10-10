

function [ ...
    classification, agreement, ...
    neighbor_dists, neighbor_classes] = ...
        KNN( ...
            data_training, classes_training, ...
            data_testing, k)
        
        
        
    % data_training should have instances in rows and features in columns
    % classes_training just needs to work in the mode function
    % data_testing is the same format as data_training
    % k is the number of neighbors that are polled
    %
    % classes gives the mode class. tie is handled by mode function
    % agreement is the number of votes in the mode divided by k
    % neighbor_dists gives distances to neighbors, in order
    % neighbor_classes gives the classes of those distances

    
    
    % run KNN

        % measure distances to training neighbors for each testing instance
            L2 = zeros( size(data_testing,1), size(data_training,1) );
            for i = 1:size(data_testing,1)
                L2(i,:) = sum( (repmat(data_testing(i,:),size(data_training,1),1) - data_training).^2, 2 )';
            end

        % sort the distances to neighbors
            [neighbor_dists,neighbor_inds] = sort(L2,2);
            neighbor_classes = classes_training( neighbor_inds );

        % pick k neighbors and check the mode to set a class
            [classification, agreement] = mode( neighbor_classes(:,1:k), 2 );
            agreement = agreement / k;
            
end