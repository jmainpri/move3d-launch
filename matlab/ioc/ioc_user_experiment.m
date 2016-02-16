function ioc_user_experiment(regularizer)

clc % clear

global ioc_regularizer;

display(regularizer)
ioc_regularizer = regularizer;

% The IOC samples should be found in


% Set the enviroment for move3d libraries
setenv('LD_LIBRARY_PATH', ... 
    ['/jim_local/move3d/install/lib:' ...
    '/home/jmainpri/catkin_ws/devel/lib:/opt/ros/indigo/lib'])
setenv('HOME_MOVE3D','/usr/local/jim_local/Dropbox/move3d/libmove3d')

% Set move3d and matlab working directories
move3d_base_dir = '/usr/local/jim_local/Dropbox/move3d/';
move3d_dir = [move3d_base_dir 'move3d-launch/'];
matlab_dir = [move3d_dir 'matlab/'];
ioc_dir = [matlab_dir 'ioc/'];
move3d_data_dir = 'move3d_tmp_data_human_trajs/';

% Empty cache from move3d
cd( [matlab_dir 'move3d_tmp_data_home'] );
system('rm *txt');

% Add move3d matlab-commands to matlab path
addpath([move3d_base_dir 'move3d-launch/matlab/ioc']);
addpath([move3d_base_dir 'move3d-launch/matlab/move3d_matlab_commands']);

% Comment it with gui
use_gui = false;
if use_gui,
    gui_str='';
else
    gui_str='-nogui';
end

%% SET MOCAP SPLITS

loo_splits = [];
use_sept    = true;
use_feb     = false;
move3d_scenario = '';
    
%% IOC PARAMETERS
% Fix seed

% Set the number of tests
nb_tests = 1; % number of calls to each sampling phase

% Set use replan demos and samples
with_replan = true;

% Get samples sequence
samples = [300];
nb_features = 36;
init_factor = 1;
data_folder = move3d_data_dir;
demo_id = -1;

% Init result struct
recovered_weights = zeros( nb_features );
feat_count = cell(1);

csvwrite( [matlab_dir, move3d_data_dir, 'samples_tmp.txt'], samples );


%% ------------------------------------------------------------------------
%% GENERATE WEIGHT VECTORS NO REPLAN  -------------------------------------
%% ------------------------------------------------------------------------
cd( matlab_dir );

nb_demo = 73;
ioc_learning( nb_demo, nb_features, samples, init_factor, ...
    data_folder, demo_id );

recovered_weights = load([data_folder 'spheres_weights_', ...
    num2str(samples(1),'%03d'), '_', num2str(regularizer), '_.txt'])';
feat_count = { load([data_folder 'spheres_features_', ...
    num2str(samples(1),'%03d'),'.txt']) };

cd( matlab_dir );
tmp_dir = 'results_current/tmp_results_noreplan/';
save([tmp_dir 'nb_demos_human_motion_noreplan_user_study_', ...
    num2str(regularizer), '_.mat'],'nb_demo');
save([tmp_dir 'feat_human_motion_noreplan_user_study_', ...
    num2str(regularizer), '_.mat'],'feat_count');
save([tmp_dir 'weig_human_motion_noreplan_user_study_', ...
    num2str(regularizer), '_.mat'], 'recovered_weights');


%% ------------------------------------------------------------------------
%% GENERATE WEIGHT VECTORS REPLAN  ----------------------------------------
%% ------------------------------------------------------------------------
if with_replan,
    cd( matlab_dir );
    
    nb_demo = 461;
    ioc_learning( nb_demo, nb_features, samples, init_factor, ...
        data_folder, demo_id );

    recovered_weights = load([data_folder 'spheres_weights_', ...
        num2str(samples(1),'%03d'), '_', num2str(regularizer), '_.txt']);
    feat_count = { load([data_folder 'spheres_features_', ...
        num2str(samples(1),'%03d'), '.txt']) };

    cd( matlab_dir );
    tmp_dir = 'results_current/tmp_results_replan/';
    save([tmp_dir 'nb_demos_human_motion_replan_user_study_', ...
    num2str(regularizer), '_.mat'], 'nb_demo');
    save([tmp_dir 'feat_human_motion_replan_user_study_', ...
    num2str(regularizer), '_.mat'], 'feat_count');
    save([tmp_dir 'weig_human_motion_replan_user_study_', ...
    num2str(regularizer), '_.mat'], 'recovered_weights');
end
