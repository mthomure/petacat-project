function DVALUE = train_glimpse_model(MODEL_NAME, POS_DIR, NEG_DIR, NUM_PROTOTYPES)

% MODEL_NAME examples: 'dogs' 'pedestrians' 'leashes'
% POS_DIR Directory of positive training images.
% NEG_DIG Directory of negative training images.
% NUM_PROTOTYPES the number of S2 prototypes in the learned model.

% TRAIN_GLIMPSE_MODEL Create a Glimpse model from training images.

% The directory structure of the Petacat project is assumed to be:
% glimpse/
%   bin/
%     train-model.sh
%     ...
%   models/
%   ...
% matlab/
%   train_glimpse_model.m
%   ...

% Determine Petacat and Glimpse paths.
PETACAT_HOME = fullfile(fileparts(mfilename('fullpath')), '..');
SCRIPT_PATH = fullfile(PETACAT_HOME, 'glimpse', 'bin', 'train-model.sh');

% Run Glimpse model, and check for errors.
CMD = [SCRIPT_PATH, ' ', MODEL_NAME, ' ', POS_DIR, ' ', NEG_DIR, ' ', NUM_PROTOTYPES];
%display(CMD)
[status, result] = system(CMD);
if status ~= 0
    error('petacat:train_glimpse_model:glimpse_error', ['Error training Glimpse model:\n\n' result]);
else
    DVALUE = str2num(result);
end
