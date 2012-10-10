function eloc = readlocs2( fname, include )

    % eloc = readlocs2( fname, include );
    %
    % reads locations from a locs file, but only the specified locations.
    % useful if you find that some of the recordings are bad and you just
    % want a locations list for the good ones.
    %
    % usage example:
    % 
    %     figure;
    % 
    %     subplot(1,3,1);   
    %     topoplot(linspace(-1,1,64),'eegmap_biosemi64.locs');
    % 
    %     subplot(1,3,2);
    %     topoplot(linspace(-1,1,64),readlocs2('eegmap_biosemi64.locs',ones(1 ,64)));
    % 
    %     subplot(1,3,3);
    %     topoplot(linspace(-1,1,64),readlocs2('eegmap_biosemi64.locs',gt(rand(1,64),.25)));

    
    
    if ~exist('fname','var') || isempty(fname)
        fname = 'eegmap_biosemi64.locs';
    end

    eloc = readlocs(fname);
    
    eloc(~include) = [];
    
    
    
end



