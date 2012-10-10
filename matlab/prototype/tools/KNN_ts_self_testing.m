
% KNN test script

% This test script classifies all of the training examples using their
% nearest neighbors (excluding themselves). This should be useful in
% determining the likely success rate based on classifier confidence using
% just the training data, allowing for a principled decision for a
% confidence level that should be used to refuse to classify.

% We see here that 75% neighborhood agreement is well over 75% correct 
% classification, and 50% agreement is actually under 50% correct 
% classification. Also, 100% agreement is nearly, but not quite, 100% 
% correctly classified (for k = 4).

    clear all;
    close all
    clc;
    
    k = 20;

    
    
% prepare dataset

    load optdigits;
    % contains:
    %   input_data
    %   target_outputs
    input_data = input_data(1:500,:);
    target_outputs = target_outputs(1:500,:);
    
    training_ratio = .75;
    inds_train = lt( randperm(size(input_data,1)), fix(size(input_data,1)*training_ratio) );
    inds_test = ~inds_train;
    
    data_training    = input_data(inds_train,:);
    classes_training = max( target_outputs(inds_train,:) .* repmat(0:9,sum(inds_train),1) ,[],2);
    % data_testing     = input_data(inds_test,:);
    % classes_testing  = max( target_outputs(inds_test,:)  .* repmat(0:9,sum(inds_test),1)  ,[],2);
    
    data_testing = data_training;
    classes_testing = classes_training;

    

% run knn

    [classification, agreement, ...
     neighbor_dists, neighbor_classes] = ...
        KNN(data_training, classes_training, data_testing, k);

    dist_min = min( neighbor_dists(:,1:k), [], 2 );
    dist_mean = mean( neighbor_dists(:,1:k), 2 );
    
    
    
% some results
    
    display(['CCR: ' num2str( sum( eq(classification,classes_testing) ) / length(classification) )]);
    display('classification class eq agreement');
    display([classification classes_testing eq(classification,classes_testing) agreement]);
    plot(eq(classification,classes_testing)+.05*rand(size(classification,1),1)-.025,agreement+.05*rand(size(classification,1),1)-.025,'.');
    xlabel('classification success');
    ylabel('neighborhood agreement');
