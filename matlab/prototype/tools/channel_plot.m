function [] = channel_plot(x,fs, scale )

    % [] = channel_plot(x,fs);
    % plots many channels of data from x in a two column format.
    % makes a best guess for scaling
    % includes time labels if sampling rate is given in fs
    % otherwise assumes a sampling rate of 256

    if ~exist('fs','var') || isempty(fs)
        fs = 256;
    end

    
    % figure out the time scale
        t = (1/fs) * (0:size(x,2)-1);
    
        
    % figure out an amplitude scaling
        if ~exist('scale','var') || isempty(scale)
            scale = 10 * median( std(x,[],2) );
        end
        
    % divide up channels into 2 groups
        r0 = 1;
        r1 = floor(size(x,1)/2);
        r2 = r1 + 1;
        r3 = size(x,1);
        
        
    if size(x,1) == 64
        labels = { ...
            'Fp1'   'AF7'   'AF3'   'F1'    'F3'    'F5'    'F7'    'FT7'   'FC5'    'FC3'    'FC1'    'C1' ...
            'C3'    'C5'    'T7'    'TP7'   'CP5'   'CP3'   'CP1'   'P1'    'P3'    'P5'    'P7'    'P9' ...
            'PO7'   'PO3'   'O1'    'Iz'    'Oz'    'POz'   'Pz'    'CPz'   'Fpz'    'Fp2'    'AF8'    'AF4' ...
            'AFz'   'Fz'    'F2'    'F4'    'F6'    'F8'    'FT8'   'FC6'   'FC4'    'FC2'    'FCz'    'Cz' ...
            'C2'    'C4'    'C6'    'T8'    'TP8'   'CP6'   'CP4'   'CP2'   'P2'    'P4'    'P6'    'P8' ...
            'P10'   'PO8'   'PO4'   'O2' };
    end

        
    figure;

        subplot(1,2,1);
        
            plot( t, ( x(r0:r1,:)/scale + repmat( (r0:r1)',1,size(x,2)) )' );
            
            ylim([r0-2,r1+2])

        subplot(1,2,2);
        
            plot( t, ( x(r2:r3,:)/scale + repmat( (r2:r3)',1,size(x,2)) )' );
        
            ylim([r2-2,r3+2])

    

end




