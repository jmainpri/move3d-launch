clear; clc

% Set the enviroment for move3d libraries
setenv('LD_LIBRARY_PATH','/home/jmainpri/openrobots/lib:/home/jmainpri/workspace/move3d/dependencies/install/lib:/home/jmainpri/workspace/move3d/install/lib')
setenv('HOME_MOVE3D','/home/jmainpri/Dropbox/move3d/libmove3d')

% Set move3d and matlab working directories
move3d_dir = '/home/jmainpri/Dropbox/move3d/move3d-launch/';
matlab_dir = [move3d_dir 'matlab/'];
ioc_dir = [matlab_dir 'ioc/'];
move3d_data_dir = 'move3d_tmp_data_human_trajs/';

% Empty cache from move3d
cd( [matlab_dir 'move3d_tmp_data_home'] );
system('rm *txt');

% Add move3d matlab-commands to matlab path
addpath('/home/jmainpri/Dropbox/move3d/move3d-launch/matlab/move3d_matlab_commands');

% Comment it with gui
use_gui = false;
if use_gui,
    gui_str='';
else
    gui_str='-nogui';
end

% Set move3d system-command, files and seed

%% KINECT DATA
move3d_scenario = '-sc ../assets/Collaboration/SCENARIOS/collaboration_test_kinect.sce';
move3d_cmd = ['move3d-qt-studio ' gui_str ' -launch SphereIOC -c pqp -f ../assets/Collaboration/TwoHumansTableKinect.p3d ' move3d_scenario ' -setgui -params ../move3d-launch/'];
file_params = 'parameters/params_collaboration_planning_bis';

%% SIMULATION DATA
% move3d_scenario = '-sc ../assets/Collaboration/SCENARIOS/collaboration_test_reach.sce';
% move3d_cmd = ['move3d-qt-studio ' gui_str ' -launch SphereIOC -c pqp -f ../assets/Collaboration/TwoHumansPlanning.p3d ' move3d_scenario ' -setgui -params ../move3d-launch/'];
% file_params = 'parameters/params_collaboration_planning';

%% IOC PARAMETERS
% Fix seed
seed = 1391184850;
% seed = seed + round(100000*rand());

% Set the number of tests
nb_tests = 1; % number of calls to each sampling phase

% Get samples sequence
samples = [2, 10, 50, 100, 300, 600, 800];
% samples = [10 50 100];
% samples = [600];
csvwrite( [matlab_dir, move3d_data_dir, 'samples_tmp.txt'], samples );

 phases(1) = true; % sampling
 phases(2) = true; % learning
 phases(3) = false; % compare

% Set move3d variables ----------------------------------------------------

move3d_set_variable( move3d_dir, file_params, 'stringParameter\\active_cost_function', 'costHumanTrajectoryCost' );
move3d_set_variable( move3d_dir, file_params, 'boolParameter\\init_spheres_cost', 'false' );
move3d_set_variable( move3d_dir, file_params, 'boolParameter\\init_human_trajectory_cost', 'true' );
move3d_set_variable( move3d_dir, file_params, 'boolParameter\\ioc_single_iteration', 'false' );
move3d_set_variable( move3d_dir, file_params, 'boolParameter\\ioc_sample_around_demo', 'true' );
move3d_set_variable( move3d_dir, file_params, 'boolParameter\\ioc_draw_demonstrations', 'true' );
move3d_set_variable( move3d_dir, file_params, 'boolParameter\\ioc_draw_samples', 'true' );
move3d_set_variable( move3d_dir, file_params, 'intParameter\\ioc_from_file_offset', '0' );
move3d_set_variable( move3d_dir, file_params, 'drawTrajVector', 'false' );

% -------------------------------------------------------------------------
% Random ------------------------------------------------------------------
% -------------------------------------------------------------------------

move3d_set_variable( move3d_dir, file_params, 'boolParameter\\ioc_load_samples_from_file', 'false' );

% DEFINITION OF THE NOISE
move3d_set_variable( move3d_dir, file_params, 'doubleParameter\\ioc_sample_std_dev', '0.00015' );  
% move3d_set_variable( move3d_dir, file_params, 'doubleParameter\\ioc_sample_std_dev', '0.0003' ); 

% -------------------------------------------------------------------------
% Call a serie of tests ---------------------------------------------------
% -------------------------------------------------------------------------

[nb_demo, nb_feature, results, recovered_weights, feat_count, feat_jac] = ioc_single_test( move3d_dir, matlab_dir, move3d_data_dir, move3d_cmd, file_params, seed, nb_tests, samples, phases  );

cd( matlab_dir );
% save('results_current/test_human_motion.mat','results');
save('results_current/feat_human_motion.mat','feat_count');
save('results_current/weights_human_motion.mat','recovered_weights');

plot_ioc_results_function( samples, results )

% plot_weights( samples, recovered_weights )
% plot_feature_gradient_sum( samples, feat_count )
% plot_feature_gradient_sum( samples, feat_jac )

cd( ioc_dir );
