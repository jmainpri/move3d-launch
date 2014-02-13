clear; clc

% Set the enviroment for move3d libraries
setenv('LD_LIBRARY_PATH','/home/jmainpri/openrobots/lib')
% setenv('LD_LIBRARY_PATH','/home/jmainpri/workspace/move3d/dependencies/install/lib:/home/jmainpri/workspace/move3d/install/lib')

% Set move3d and matlab working directories
move3d_dir = '/home/jmainpri/workspace/move3d/move3d-launch/';
matlab_dir = '/home/jmainpri/workspace/move3d/move3d-launch/matlab/';

% Empty cache from move3d
cd( [matlab_dir 'move3d_tmp_data'] );
system('rm *txt');

% Add move3d matlab-commands to matlab path
addpath('/home/jmainpri/workspace/move3d/move3d-launch/matlab/move3d_matlab_commands');

% Set move3d system-command, files and seed
move3d_cmd = 'move3d-qt-studio -launch SphereIOC -c pqp -f ../assets/IOC/Plane_Multi_squares.p3d -setgui -params ../move3d-launch/';
file_params = 'parameters/params_spheres_ioc_squares';
seed = 1391184849;

% Set the number of tests
nb_tests = 30;

% Set IOC variables (should be matched in move3d)
% -------------------------------------------------------------------------
nb_demo = 1;
nb_features = 16; % 64 + 1 (smoothness)
nb_sampling_phase = 20; % in c++ (move3d)
nb_samples = 100;
min_samples = 10;
max_samples = nb_samples;

% Get samples sequence

% samples = 1:nb_sampling_phase;
% for i=0:nb_sampling_phase-1, 
%     samples(i+1) = floor( min_samples + i*(max_samples-min_samples)/(nb_sampling_phase-1) );
% end
samples = 16*[1:10];

% Set move3d variables ----------------------------------------------------

move3d_set_variable( move3d_dir, file_params, 'stringParameter\\active_cost_function', 'costSquares' );
move3d_set_variable( move3d_dir, file_params, 'boolParameter\\ioc_load_samples_from_file', 'false' );

% -------------------------------------------------------------------------
% Call a serie of tests ---------------------------------------------------
% -------------------------------------------------------------------------

move3d_set_variable( move3d_dir, file_params, 'doubleParameter\\ioc_sample_std_dev', '1.00' );

results = ioc_single_test( move3d_dir, matlab_dir, move3d_cmd, file_params, seed, nb_tests, nb_demo, nb_features, samples  );
plot_ioc_results_function( samples, results )

cd( matlab_dir );
save('results_current/test1.mat','results');

% -------------------------------------------------------------------------

% move3d_set_variable( move3d_dir, file_params, 'doubleParameter\\ioc_sample_std_dev', '0.05' );
% 
% results = ioc_single_test( move3d_dir, matlab_dir, move3d_cmd, file_params, seed, nb_tests, nb_demo, nb_features, samples  );
% plot_ioc_results_function( samples, results )
% 
% cd( matlab_dir );
% save('results_current/test2.mat','results');

% -------------------------------------------------------------------------

% move3d_set_variable( move3d_dir, file_params, 'doubleParameter\\ioc_sample_std_dev', '0.03' );
% 
% results = ioc_single_test( move3d_dir, matlab_dir, move3d_cmd, file_params, seed, nb_tests, nb_demo, nb_features, samples  );
% plot_ioc_results_function( samples, results );
% 
% cd( matlab_dir );
% save('results_current/test3.mat','results');
