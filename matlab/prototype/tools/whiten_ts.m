
% whiten test script

    clear all;
    close all
    clc;

    
    
    load optdigits;
    % input_data
    % target_outputs
    input_data = input_data(1:10,:);
    target_outputs = target_outputs(1:10,:);
    
    figure
    for i = 1:10
        subplot(2,10,i);
        imshow( mat2gray( reshape( input_data(i,:), 8,8 ) ) );
    end
    
    input_data = whiten(input_data);
    
    for i = 1:10
        subplot(2,10,10+i);
        imshow( mat2gray( reshape( input_data(i,:), 8,8 ) ) );
    end
    
    
    
    load optdigits;
    % input_data
    % target_outputs
    input_data = input_data(1:50,:);
    target_outputs = target_outputs(1:50,:);
    
    figure
    for i = 1:10
        subplot(2,10,i);
        imshow( mat2gray( reshape( input_data(i,:), 8,8 ) ) );
    end
    
    input_data = whiten(input_data);
    
    for i = 1:10
        subplot(2,10,10+i);
        imshow( mat2gray( reshape( input_data(i,:), 8,8 ) ) );
    end
    
    
