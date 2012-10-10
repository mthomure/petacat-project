
function subplot2( rows, cols, rp0, cp0, rpf, cpf )

    % subplot2( rows, cols, rp, cp )
    %   or
    % subplot2( rows, cols, rp0, cp0, rpf, cpf );
    

    if nargin < 6
        rpf = rp0;
        cpf = cp0;
    end

    subplot( rows, cols, [ spi(cols,rp0,cp0) spi(cols,rpf,cpf) ] );
    
end

function ind = spi(cols,rp,cp)

    ind = (rp-1)*cols + cp;
    
end