function [y,band,power,type] = fake_eeg(duration,fs,plot_flag)
    

    % [y,band,power,type] = fake_eeg(duration,fs,plot_flag)
    

    ifndef('duration',  5     );
    ifndef('fs',        256   );
    ifndef('plot_flag', false );
    
    
    
    % simulate a little EEG data

        % timing
            
            t = linspace( 0, duration, fs*duration );

            
            
        % brainwave parameters
            
            type = { 'delta', 'theta', 'alpha', 'beta', 'gamma', 'mu' };

            band(1,:) = [  1    4 ]; % delta
            band(2,:) = [  4    8 ]; % theta
            band(3,:) = [  8   13 ]; % alpha
            band(4,:) = [ 13   30 ]; % beta
            band(5,:) = [ 30 fs/2 ]; % gamma
            band(6,:) = [  8   13 ]; % mu

            % power = [1 1 1 1 1 0];
            power = [rand(1,5) 0];

            

        % signal
            
            filter_order = 100;
            for i = 1:length(type)
                temp_signal = fir_band_pass( rand(1,length(t)), fs, band(i,1), band(i,2), filter_order, false);
                temp_signal = power(i) * temp_signal / std(temp_signal);
                x(i,:) = temp_signal;
            end

            y = sum(x);


        if plot_flag
            figure('Name','1 original components')
                hold on;

                for i = 1:size(x,1)
                    c = (i-1)/(size(x,1)-1);
                    plot(t,x(i,:)+2*i,'color',[c 0 1-c]);
                end

                legend(type);

                hold off;
        end
        
        
end


