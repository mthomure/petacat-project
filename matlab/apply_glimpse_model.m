function DVALUE = apply_glimpse_model(MODEL_NAME, IMAGE)

% APPLY_GLIMPSE_MODEL Perform visual object detection.
% This function predicts the contents of an image by applying a given Glimpse model.
% The function's return value indicates the degree to which the given model fits the image,
% with large positive (negative) values indicating a strongly positive (negative) degree of fit.
% This value is derived from the model classifier's decision value.
%
% APPLY_GLIMPSE_MODEL(NAME, IMAGE) returns the decision value for model NAME when applied to IMAGE.
% The IMAGE argument should contain a 2D array, indexed by height and width.
%
% Example: Given a model for predicting "dog" vs "not dog", and another predicting "car" vs "not car",
% and an IMAGE of a dog, we would expect that
%   APPLY_GLIMPSE_MODEL('dogs', IMAGE) > 0
%   APPLY_GLIMPSE_MODEL('cars', IMAGE) < 0
% Of course, this depends on the training data, etc.

% Name of temporary file holding image data.
TMP_IMG_NAME = 'tmp.mat';

% The directory structure of the Petacat project is assumed to be:
% glimpse/
%   bin/
%     apply-model.sh
%     ...
%   models/
%   ...
% matlab/
%   apply_glimpse_model.m
%   ...

% Determine Petacat and Glimpse paths.
PETACAT_HOME = fullfile(fileparts(mfilename('fullpath')), '..');
SCRIPT_PATH = fullfile(PETACAT_HOME, 'glimpse', 'bin', 'apply-model.sh');
TMP_IMG = fullfile(PETACAT_HOME, TMP_IMG_NAME);

% Store image data to temporary file using Matlab V6 format.
save(TMP_IMG, 'IMAGE', '-v6');

% Run Glimpse model, and check for errors.
CMD = [SCRIPT_PATH, ' ', MODEL_NAME, ' ', TMP_IMG];
[status, result] = system(CMD);
if status ~= 0
  error('petacat:apply_glimpse_model:glimpse_error', ['Error running Glimpse model: ' result]);
end
DVALUE = str2num(result);
