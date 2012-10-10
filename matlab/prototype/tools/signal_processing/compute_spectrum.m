function [X,f] = compute_spectrum(x, fs, f_max, N, plot_flag )
    %[X,f] = compute_spectrum(x, fs, f_max, N, plot_flag );
    %
    % x         input signal
    % fs        sampling frequency
    % f_max     maximum frequency of interest
    % N         number of frequencies being evaluated (try 2^10)
    % plot_flag controls whether a plot is displayed
    %
    % X         one sided magnitude specturm
    % f         are the frequencies (the axis for X)
    
    
    
    if ~exist('fs','var')    || isempty(fs)
        fs = 1; end
    if ~exist('f_max','var') || isempty(f_max) || f_max > fs/2
        f_max = fs/2; end
    if ~exist('N','var')     || isempty(N)
        N = 2^10; end
    if ~exist('plot_flag','var') || isempty(plot_flag)
        plot_flag = 1; end
    
    
    
    %decimate signal to maximum frequency of interest
    
        % fs / d = 2 * fm  =>  d = fs / (2*fm)
        d_level = fix( fs / (2*f_max) );
        x_d = decimate( x, d_level );
        fs_d = fs / d_level;
   
        
        
    %take the ones sided fft
    
        X = abs( fft( x_d, N ));
        X = X(1:N/2);
        f = fs_d/N * [0:N/2-1];   %how much of 2pi does each measure represent? sampling freq over fft size

        
        
    %plot, if requested
    
        if plot_flag
            % figure('color','w');
            plot(f,X);
            xlabel('Hz');
            ylabel('|FFT|');
        end
   
        
        
end

 