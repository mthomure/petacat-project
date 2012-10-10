function ICs = imICA( signals_in, num_ICs )
% ICs = imICA( signals_in, num_ICs )
% Returns ICs, the independent components of signals_in. If signals_in is
% an array of 1-D signals, i.e. size(signals_in) =
% [signal_length , num_signals], then size(ICs) = [signal_length , num_ICs]
% where the variable num_ICs is set in the code.
%
% Otherwise, if size(signals_in) = [X,Y,num_signals], then the input is
% interpreted as a set of [X,Y]-sized grayscaleimage patches, and thus 
% size(ICs) = [X,Y,num_ICs].
%
% Example use for patches of size 16x16x3 (color 16x16 patches):
%
% signals_in = zeros(16*16*3,50000);
% for i = 1:50000
%   signals_in(:,i) = reshape( patches(:,:,:,i) );
% end
% ICs = run_ica( signals_in );
% for i = 1:100
% subplot(10,10,i),imshow(mat2gray(reshape(ICs(:,i),[16,16,3])));
% end
%
% Almost all code taken from 'imageica' package of Hyvarinen.



%% Set administrative options

    global Verbose
    Verbose = false;



%% Set ICA options
   
    num_ICA_iterations = 80;
    
    ifndef('num_ICs',size(signals_in,1));


%% Reshape data if necessary

    if Verbose
        fprintf(1,'Reshaping data. ')
    end

    if ndims( signals_in ) == 3 % a set of 2D image patches

        dims = 3;
        [ X , Y , num_signals_in ] = size( signals_in );
        data = zeros( X*Y , num_signals_in );

        if Verbose
            fprintf(1,['Interpreting data as 2D image patches of size ' , ...
                '[%i,%i].\n'], X , Y );
        end        

        for i = 1:num_signals_in
            data(:, i ) = ...
                reshape( signals_in(:,:, i ) , [ X*Y , 1 ] );
        end

    elseif ndims( signals_in ) == 2 % a set of 1D signals

        dims = 2;
        [signal_length , num_signals_in] = size(signals_in);
        data = signals_in;

        if Verbose
            fprintf(1,['Interpreting data as 1D signals of length %i.\n'], ...
                signal_length );
        end

    else
        fprintf(1,'Warning: ndims(signals_in) != 2 or 3 (run_ica.m)');
        exit;
    end



%% Subtract mean

    if Verbose
        fprintf(1,'Subtracting mean.\n');
    end

    if dims == 3
        
%         size(data)
%         size(mean(data))

        data = data - repmat(mean(data),size(data,1),1);
        % data = data - ones( X*Y , 1 ) * mean(X);
    else % dims == 2
        data = data - ones( signal_length , num_signals_in );
    end



%% Whiten: eigenvalue decomposition

    if Verbose
        fprintf(1,['Whitening. Taking first %i components.\n'], num_ICs);
    end

    covarianceMatrix = data * data' / num_signals_in;
    [E, D] = eig(covarianceMatrix);

    % Sort the eigenvalues, select subset, and whiten
    [~,order] = sort(diag(-D));
    E = E(:,order( 1 : num_ICs ));
    d = diag(D);
    d = real(d.^(-0.5));
    D = diag(d(order( 1 : num_ICs )));
    whitened_data = D*E'*data;

    whiteningMatrix = D*E';
    dewhiteningMatrix = E*D^(-1);



%% Get ICs

    if Verbose
        fprintf(1,'Estimating independent components for %i iterations.\n',...
            num_ICA_iterations);
    end

    p.seed = 1;
    p.write = 5;
    p.model = 'ica';
    p.algorithm = 'fixed-point';
    p.components = num_ICs;
    A = estimate_ICs( whitened_data, whiteningMatrix, dewhiteningMatrix,...
        'ica.mat', p , num_ICA_iterations);



%% Write variables for output

    if dims == 3

        ICs = zeros( X , Y , num_ICs );
        for i = 1:num_ICs
           ICs(:,:,i) = reshape( A(:,i) , [X,Y]);
        end

    elseif dims == 2

        ICs = A;

    end

    if Verbose
        fprintf('\n');
    end
    
    
    
end
























function A = estimate_ICs( X, whiteningMatrix, dewhiteningMatrix, fname,...
    p , num_iterations)
% estimate - algorithms for topographic, subspace, and standard ICA
%
% SYNTAX:
% estimate( whiteningMatrix, dewhiteningMatrix, fname, dims );
%
% NOTE: X passed as global!
%
% X                  preprocessed (whitened) sample vectors in columns
% whiteningMatrix    transformation from observation space to X-space
% dewhiteningMatrix  inverse transformation
% fname              name of file to write
%
% PARAMETERS COMMON TO ALL ALGORITHMS
%
% p.seed             random number generator seed
% p.write            iteration interval for writing results to disk
%
% ICA (with FastICA algorithm, tanh nonlinearity)
%
% p.model            'ica'
% p.algorithm        'fixed-point'
% p.components       number of ICA components to estimate
%
% ISA (gradient descent with adaptive stepsize)
%
% p.model            'isa'
% p.algorithm        'gradient'
% p.groupsize        dimensionality of subspaces
% p.groups           number of independent subspaces to estimate
% p.stepsize         starting stepsize
% p.epsi             small positive constant
%
% TOPOGRAPHIC ICA (gradient descent with adaptive stepsize)
%
% p.model            'tica'
% p.algorithm        'gradient'
% p.xdim             columns in map
% p.ydim             rows in map
% p.maptype          'standard' or 'torus'
% p.neighborhood     'ones3by3' (only one implemented so far)
% p.stepsize         starting stepsize
% p.epsi             small positive constant
%

%-------------------------------------------------------------------
% PRELIMINARIES
%-------------------------------------------------------------------
global Verbose

if Verbose
    % Print options
    fprintf('You have selected the following options...\n');
    p
end

% If we have the TICA model, generate the neighborhood
if strcmp(p.model,'tica')
    
    % Neighborhood matrix: NB(i,j) = strength of unit j in neighb. of
    % unit i. In addition, we will create a matrix NBNZ, which gives
    % the positions of the non-zero entries in NB, to lower the
    % computational expenses.
    fprintf('Generating neighborhood matrix...\n');
    [NBNZ,NB] = GenerateNB( p );
    
end

%[WL] X now passed in... [/WL]
% Take the data from the global variable
% global X;
N = size(X,2);

%-------------------------------------------------------------------
% SETTING UP THE STARTING POINT...
%-------------------------------------------------------------------

% Initialize the random number generator.
rand('seed',p.seed);

% Take random initial vectors...
if strcmp(p.model,'ica')
    B = randn(size(X,1),p.components);
elseif strcmp(p.model,'isa')
    B = randn(size(X,1),p.groupsize*p.groups);
elseif strcmp(p.model,'tica')
    B = randn(size(X,1),p.xdim*p.ydim);
end

% ...and decorrelate (=orthogonalize in whitened space)
B = B*real((B'*B)^(-0.5));
n = size(B,2);

%-------------------------------------------------------------------
% START THE ITERATION...
%-------------------------------------------------------------------

% Print the time when started (and save along with parameters).
c=clock;
if c(5)<10, timestarted = ['Started at: ' int2str(c(4)) ':0' int2str(c(5))];
else timestarted = ['Started at: ' int2str(c(4)) ':' int2str(c(5))];
end
if Verbose
    fprintf([timestarted '\n']);
end
p.timestarted = timestarted;

% Initialize iteration counter
iter=0;

% Use starting stepsize for gradient methods
if strcmp(p.algorithm,'gradient')
    stepsize = p.stepsize;
    obj = [];
    objiter = [];
end

% [WL] replace with for-loop:
% Loop forever, writing result periodically
%while 1
for cur_iteration = 1:num_iterations 

    % Increment iteration counter
    iter = iter+1;
    if Verbose
        fprintf('(%d)\n',iter);
    end
        
    %-------------------------------------------------------------
    % FastICA step
    %-------------------------------------------------------------
    
    if strcmp(p.model,'ica') & strcmp(p.algorithm,'fixed-point')
        
        % This is tanh but faster than matlabs own version
        hypTan = 1 - 2./(exp(2*(X'*B))+1);
        
        % This is the fixed-point step
        B = X*hypTan/N - ones(size(B,1),1)*mean(1-hypTan.^2).*B;
        
    end
    
    %-------------------------------------------------------------
    % ISA gradient
    %-------------------------------------------------------------
    
    if strcmp(p.model,'isa') & strcmp(p.algorithm,'gradient')
        
        % Calculate linear filter responses and their squares
        U = B'*X; Usq = U.^2;
        
        % For each subspace
        for i=1:p.groups
            
            % These are the columns of B making up the subspace
            cols = (i-1)*p.groupsize+(1:p.groupsize);
            
            % Calculate nonlinearity of subspace energy
            g = -((p.epsi + sum(U(cols,:).^2)).^(-0.5));
            
            % Calculate gradient
            dB(:,cols) = X*(U(cols,:).*(ones(p.groupsize,1)*g))'/N;
            
        end
        
    end
    
    %-------------------------------------------------------------
    % TICA gradient
    %-------------------------------------------------------------
    
    if strcmp(p.model,'tica') & strcmp(p.algorithm,'gradient')
        
        % Calculate linear filter responses and their squares
        U = B'*X; Usq = U.^2;
        
        % Calculate local energies
        for ind=1:n
            E(ind,:) = NB(ind,NBNZ{ind}) * Usq(NBNZ{ind},:);
        end
        
        % Take nonlinearity
        g = -((p.epsi + E).^(-0.5));
        
        % Calculate convolution with neighborhood
        for ind=1:n
            F(ind,:) = NB(ind,NBNZ{ind}) * g(NBNZ{ind},:);
        end
        
        % This is the total gradient
        dB = X*(U.*F)'/N;
        
    end
    
    %-------------------------------------------------------------
    % ADAPT STEPSIZE FOR GRADIENT ALGORITHMS
    %-------------------------------------------------------------
    
    if strcmp(p.algorithm,'gradient')
        
        % Perform this adaptation only every 5 steps
        if rem(iter,5)==0 | iter==1
            
            % Take different length steps
            Bc{1} = B + 0.5*stepsize*dB;
            Bc{2} = B + 1.0*stepsize*dB;
            Bc{3} = B + 2.0*stepsize*dB;
            
            % Orthogonalize each one
            for i=1:3, Bc{i} = Bc{i}*real((Bc{i}'*Bc{i})^(-0.5)); end
            
            % Calculate objective values in each case
            for i=1:3
                
                % ISA objective
                if strcmp(p.model,'isa')
                    Usq = (Bc{i}'*X).^2;
                    for ind=1:p.groups,
                        cols = (ind-1)*p.groupsize+(1:p.groupsize);
                        E(ind,:) = sum(Usq(cols,:));
                    end
                    objective(i) = mean(mean(sqrt(p.epsi+E)));
                    
                    % TICA objective
                elseif strcmp(p.model,'tica')
                    Usq = (Bc{i}'*X).^2;
                    for ind=1:n, E(ind,:)= NB(ind,NBNZ{ind}) * Usq(NBNZ{ind},:); end
                    objective(i) = mean(mean(sqrt(p.epsi+E)));
                end
                
            end
            
            % Compare objective values, pick step giving minimum
            if objective(1)<objective(2) & objective(1)<objective(3)
                % Take shorter step
                stepsize = stepsize/2;
                fprintf('Stepsize now: %.4f\n',stepsize);
                obj = [obj objective(1)];
            elseif objective(1)>objective(3) & objective(2)>objective(3)
                % Take longer step
                stepsize = stepsize*2;
                fprintf('Stepsize now: %.4f\n',stepsize);
                obj = [obj objective(3)];
            else
                % Don't change step
                obj = [obj objective(2)];
            end
            
            objiter = [objiter iter];
            fprintf('\nObjective value: %.6f\n',obj(end));
            
        end
        
        B = B + stepsize*dB;
        
    end
    
    
    %-------------------------------------------------------------
    % Ortogonalize (equal to decorrelation since we are
    % in whitened space)
    %-------------------------------------------------------------
    
    B = B*real((B'*B)^(-0.5));
    
    %-------------------------------------------------------------
    % [WL] DO NOT Write to disk
    %-------------------------------------------------------------
    
    % if rem(iter,p.write)==0 | iter==1
    %
    %     A = dewhiteningMatrix * B;
    %     W = B' * whiteningMatrix;
    %     fprintf(['Writing file: ' fname '...']);
    %     if strcmp(p.algorithm,'gradient')
    %       eval(['save ' fname ' W A p iter obj objiter']);
    %     else
    %       eval(['save ' fname ' W A p iter']);
    %     end
    %     fprintf(' Done!\n');
    %
    %   end
    
end

A = dewhiteningMatrix * B;
W = B' * whiteningMatrix; %[WL] might want this later.
return;

end











%-----------------------------------------------------------------
% GenerateNB - generates the neighborhood matrix for TICA
%-----------------------------------------------------------------
function [NBNZ,NB] = GenerateNB( p )

% This will hold the neighborhood function entries
NB = zeros(p.xdim*p.ydim*[1 1]);

% This is currently the only implemented neighborhood
if strcmp(p.neighborhood,'ones3by3')==0
    error('No such neighborhood allowed!');
end

% Step through nodes one at a time to build the matrix
ind = 0;
for y=1:p.ydim
    for x=1:p.xdim
        
        ind = ind+1;
        
        % Rectangular neighbors
        [xn,yn] = meshgrid( (x-1):(x+1), (y-1):(y+1) );
        xn = reshape(xn,[1 9]);
        yn = reshape(yn,[1 9]);
        
        if strcmp(p.maptype,'torus')
            
            % Cycle round
            i = find(yn<1); yn(i)=yn(i)+p.ydim;
            i = find(yn>p.ydim); yn(i)=yn(i)-p.ydim;
            i = find(xn<1); xn(i)=xn(i)+p.xdim;
            i = find(xn>p.xdim); xn(i)=xn(i)-p.xdim;
            
        elseif strcmp(p.maptype,'standard')
            
            % Take only valid nodes
            i = find(yn>=1 & yn<=p.ydim & xn>=1 & xn<=p.xdim);
            xn = xn(i);
            yn = yn(i);
            
        else
            error('No such map type!');
        end
        
        % Set neighborhood
        NB( ind, (yn-1)*p.xdim + xn )=1;
        
    end
end

% For each unit, calculate the non-zero columns!
for i=1:p.xdim*p.ydim
    NBNZ{i} = find(NB(i,:));
end

return;




end








