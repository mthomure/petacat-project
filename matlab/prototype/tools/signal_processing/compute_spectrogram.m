function [X, xaxis, yaxis] =  compute_spectrogram( x, fs, num_samples_f, spectro_freq, window_width, plot_flag )
    %
    % x             signal
    % fs            sampling rate
    % num_samples_f frequency resolution
    % spectro_freq  frequency of spectrogram sampling
    % window_width  width of sampes (in seconds)
    % plot_flag     show the plot or not

    
    
    if ~exist('fs','var') || isempty(fs)
        fs = 1; end;
    if ~exist('num_samples_f','var') || isempty(num_samples_f)
        num_samples_f = 2^10; end;
    if ~exist('spectro_freq','var') || isempty(spectro_freq)
        spectro_freq = .2 * fs; end;
    if ~exist('window_width','var') || isempty(window_width)
        window_width = 2*fs; end;
    if ~exist('plot_flag','var') || isempty(plot_flag)
        plot_flag = true; end;
    
    

    % set up our sampling centers
        duration = length(x) / fs;
        window_centers = linspace( 0, duration, spectro_freq * duration );
        window_centers( gt(window_centers,duration-window_width/2) ) = [];
        window_centers( lt(window_centers,window_width/2) ) = [];

    
        
    % spectrogram!

        for i = 1:length(window_centers)

            cur_center = window_centers(i);
            ind_0 = fix( fs * (cur_center - window_width/2) ) + 1;
            ind_f = fix( fs * (cur_center + window_width/2) );

            cur_section = x(end,ind_0:ind_f);
            cur_section = cur_section .* blackman(length(cur_section))';

            temp = abs( fft( cur_section, num_samples_f ));
            X(i,:) = temp(1:end/2);

        end

        [xaxis,yaxis] = ...
            meshgrid( ...
                linspace( 0, fs/2, size(X,2) ), ...
                linspace( min(window_centers), max(window_centers), size(X,1) ) );

            
            
    if plot_flag
    
            mesh( xaxis, yaxis, X );

            title( 'spectrogram');
            xlabel('freq (hz)');
            ylabel('time (s)');

            axis tight;
            view(90,90);
            
    end
