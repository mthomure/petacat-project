clear all; close all; clc;



% generate a signal that changes over time

    fs = 256;
    duration = 5;
    N = fs * duration;
    t = linspace( 0, duration, N );

    f = [20 60];
    for i = 1:length(f)
        x(i,:) = sin( f(i) * 2*pi * t );
    end
    x(end+1,:) = x(1,:).*linspace(1,0,size(x,2)) + x(2,:).*linspace(0,1,size(x,2));

    

% spectrogram!

    num_samples_f = 2^10;
    spectro_f_resolution = 2^10;
    spectro_freq = 10;
    window_width = .5;
    plot_flag = true;
    [X, xaxis, yaxis] =  compute_spectrogram( x, fs, num_samples_f, spectro_freq, window_width, plot_flag );
    


