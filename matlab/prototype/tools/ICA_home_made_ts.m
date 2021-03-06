% function [out] = ica_ts2( )

% ica test script


clear all; close all; clc;


N = 2000;   % instances
m = 2;      % dimensions

show_figs = true;


% uncorrelated starting point
    a = -sqrt(3);
    b =  sqrt(3);
    
    s = (b-a) * rand(m,N) + a;
    %[~,~,s] = laplace(rand(1,N),0,1);
    s(2:m,:)  = (b-a) * rand(m-1,N) + a;
    
        if show_figs
            
            figure('Name','source data');
            title('Source data');
            subplot2(3,2,1,1,2,2)
            plot( s(1,:), s(2,:), '.' ); axis equal;
            subplot2(3,2,3,1);
            hist( s(1,:),20 );
            xlabel('Feature 1');
            subplot2(3,2,3,2);
            hist( s(2,:),20 );
            xlabel('Feature 2');
            
        end

        
% turn into training data (make dependent)
    % A = rand( m, m ); % random mixing matrix
    
    % A = [2 0; 2 -1];
    A = [2 -1; 2 1];
    
    x = A * s;

%         if show_figs
%             figure('Name','mixed data');
%             plot( x(1,:), x(2,:), '.' );
%             axis equal;
%         end
        
        if show_figs
            figure('Name','mixed data');
            subplot2(3,2,1,1,2,2)
            plot( x(1,:), x(2,:), '.' ); axis equal;
            title('Mixed sources');
            xlabel('Feature 1');
            ylabel('Feature 2');
            subplot2(3,2,3,1);
            hist( x(1,:),20 );
            xlabel('Feature 1');
            subplot2(3,2,3,2);
            hist( x(2,:),20 );
            xlabel('Feature 2');
        end

        
% center and whiten x
    xu = whiten(x);
    
        if show_figs
            figure('Name','whitened data');
            plot( xu(1,:), xu(2,:), '.' );
            axis equal;
        end

        
% independence optimization function
    W0 = rand(size(A))-.5;  % initial state for unmixing matrix

    kurt = @(y) mean( y.^4,2 ) - 3*(mean( y.^2,2 )).^2;
    
    opt = @(W) -1 * sum( kurt(whiten( W * xu )).^2 );
    % opt = @(W) -1 * sqrt((kurt(whiten( W * xu ))).^2) + 2*abs(corr((W(1,:) * xu)',(W(2,:) * xu)'));
   
    Wf = fminsearch( @(W) opt(W), W0 );
    
    sa = whiten( Wf * xu );

%         if show_figs
%             figure('Name', 'recovered sources');
%             plot(sa(1,:), sa(2,:), '.' );
%             axis equal;
%         end
        

        sb(1,:) = sa(1,:);
        sa(1,:) = sa(2,:);
        sa(2,:) = sb(1,:);
        
        if show_figs
            
            figure('Name','recovered sources');
            title('Recovered sources');
            xlabel('Feature 1');
            ylabel('Feature 2');
            subplot2(3,2,1,1,2,2)
            plot( sa(1,:), sa(2,:), '.' ); axis equal;
            subplot2(3,2,3,1);
            hist( sa(1,:),20 );
            xlabel('Feature 1');
            subplot2(3,2,3,2);
            hist( sa(2,:),20 );
            xlabel('Feature 2');
            
        end





% end

      
        
        
% function [xu] = whiten(x)
% 
%     xu = x - repmat(mean(x,2),1,size(x,2)); % center
%     [E,D] = eig( cov(xu'));
%     Du = diag( diag(D).^(-.5), 0 );
%     xu = E * Du * E' * xu;
%     
% end

