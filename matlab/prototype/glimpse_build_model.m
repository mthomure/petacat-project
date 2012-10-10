% building new models in glimpse
% 
% - http://packages.python.org/glimpse/
% - Training script: train_model.py and train_models.sh under glimpse/bin
% - documentation is sparse :(
% - If you want to train a new category, try:
% - python train-model.py MODEL_DIR MODEL_NAME TRAIN_POS TRAIN_NEG PARAMS NUM_PROTOTYPES
% - (see train-model.py for a usage example)
% - This stores the trained model in MODEL_DIR/MODEL_NAME.dat
% - MODEL_DIR	output directory for the model
% - TRAIN_POS	directory with the set of positive training examples
% - TRAIN_NEG 	directory with the set of negative examples
% - PARAMS  	the path to a file containing model parameters ( use glimpse/rc/model.params )
% - NUM_PROTOTYPES	the number of prototypes ( use 200 to match earlier models )
% - For example, you could train a new "llama" model using:
% - python train-model.py glimpse/models llamas images/llamas images/not-llamas glimpse/rc/model.params 200
% - run from the petacat-project directory.


dir_glimpse     = '/Users/Max/Desktop/petacat-project/glimpse';



model_name      = 'dogs-new';
dir_targets     = '/Users/Max/Desktop/training-sets/dogs';
dir_distractors = '/Users/Max/Desktop/training-sets/dist_dogs';

dir_destination = [dir_glimpse '/models/'];
parameter_file  = [dir_glimpse '/rc/model.params'];

py_file = [dir_glimpse '/bin/train-model.py'];

num_prototypes  = 200;

command_train = sprintf('%s %s %s %s %s %s %d', ...
                    py_file, ...
                    dir_destination, ...
                    model_name, ...
                    dir_targets, ...
                    dir_distractors, ...
                    parameter_file, ...
                    num_prototypes );

[status,result] = system(command_train);
display('done');





















