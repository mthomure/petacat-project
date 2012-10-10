function [y,b] = fir_band_pass(x, fs, f_low, f_high, filter_order, causal_flag)
%
%   y = fir_band_pass( x, fs, f_low, f_high, filter_order, causal_flag )
%   when unitless, highest frequency cycle is 2 pixels, max frequency is
%   then .5 cycles per pixel (or sample)
%
%   you can do any decimating on your own.
%
%   y:  output signal
%
%   x:              input signal
%   fs:             sampling frequency of the input signal
%   f_low:          cutoff frequency of the filter. if <= 0,    then lowpass with f_high
%   f_high:         cutoff frequency of the filter. if >= fs/2, then highpass with f_low
%   filter_order:   is the order of the filter
%   causal_flag:    denotes a causal (1) or non-causal (0) filter
   


    % default parameters
    
        if ~exist('fs','var') || isempty(fs); 
            fs = 1; end
        if ~exist('f_low','var') || isempty(f_low); 
            f_low = 0; end
        if ~exist('f_high','var') || isempty(f_high); 
            f_high = fs/2; end
        if ~exist('filter_order','var') || isempty(filter_order); 
            filter_order = min([fix(length(x)/4) 100]); end
        if ~exist('causal_flag','var') || isempty(causal_flag); 
            causal_flag = 0; end

    
    
    % normalize frequencies to 0,1
    
        f_low_n  = f_low  / (fs/2);
        f_high_n = f_high / (fs/2);


        
    % decide on high, low, or bandpass
    % and generate the fir filter
    
        if f_low <= 0
            b = fir1(filter_order, f_high_n, 'low');
        %    display('low');
        elseif f_high >= fs/2
            b = fir1(filter_order, f_low_n,  'high');
        %    display('high');
        else
            b = fir1(filter_order, [f_low_n f_high_n], 'bandpass');
        %    display('bandpass');
        end
        
        a = 1;

        
        
    % filter
    
        if logical(causal_flag)
            y = filter(b,a,x);
        else
            y = filtfilt(b,a,x);
        end

    
    
end