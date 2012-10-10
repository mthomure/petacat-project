% band pass test script
    clear all; close all;

    
    
    FILTER_ORDER = 100; % at least over 100, really as high as you can get it. less than signal length / 3.
    
    
    
% simulate a little EEG data

    % timing
        fs = 256;       % sample frequency in hz
        duration = 20;  % seconds
        t = linspace( 0, duration, fs*duration );

    % brainwave parameters
        type = { 'delta', 'theta', 'alpha', 'beta', 'gamma', 'mu' };

        range(1,:) = [  0    4 ]; % delta
        range(2,:) = [  4    8 ]; % theta
        range(3,:) = [  8   13 ]; % alpha
        range(4,:) = [ 13   30 ]; % beta
        range(5,:) = [ 30 fs/2 ]; % gamma
        range(6,:) = [  8   13 ]; % mu

        % power = [1 1 1 1 1 0];
        power = [rand(1,5) 0];
    
    
    % signal
        for i = 1:length(type)
            temp_signal = fir_band_pass( rand(1,length(t)), fs, range(i,1), range(i,2), FILTER_ORDER, false);
            temp_signal = temp_signal / std(temp_signal);
            temp_signal = temp_signal * power(i);
            x(i,:) = temp_signal;
        end

        y = sum(x);
    
        
        
        figure('Name','1 original components')
            hold on;

            for i = 1:size(x,1)
                c = (i-1)/(size(x,1)-1);
                plot(t,x(i,:)+2*i,'color',[c 0 1-c]);
            end

            legend(type);

            hold off;
    
            

        figure('Name','2 composite')
            
            plot(t,y,'black');
            legend('combined');
            
        
        
        compute_spectrum( y, fs );
        
        num_samples_f = 2^10;
        spectro_freq = 10;
        window_width = .5;
        plot_flag = 1;
        figure;
        y_spectrogram = compute_spectrogram( y, fs, num_samples_f, spectro_freq, window_width, plot_flag );
        
    
            
        
        
% filtered

    causal_flag  = 0;
    plot_flag    = 0;
    
    z = zeros(size(x));
    for i = 1:size(x,1)
        f_low  = range(i,1);
        f_high = range(i,2);
        z(i,:) = fir_band_pass(x(i,:), fs, f_low, f_high, FILTER_ORDER, causal_flag);
    end
    
   
    
    
    
    figure('Name','3 recovered components')
        hold on;

        N = 2^10;
        f_max = (fs/2)-1;
        
        power_est = zeros(size(power));
        for i = 1:size(x,1)
            c = (i-1)/(size(x,1)-1);
            plot(t,z(i,:)+2*i,'color',[c 0 1-c]);
            [X,f] = compute_spectrum(z(i,:), fs, f_max, N, 0 );
            
            power_est(i) = std(z(i,:));
        end

        legend(type);

        hold off;
        
        display(power);
        display(power_est);
        display(abs(power - power_est)./abs(power));
        
    
    
    
       