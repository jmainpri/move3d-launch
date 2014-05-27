clear; clc

% Set the enviroment for move3d libraries
setenv('LD_LIBRARY_PATH', '')
setenv('LD_LIBRARY_PATH','/home/jmainpri/openrobots/lib:/home/jmainpri/workspace/move3d/dependencies/install/lib:/home/jmainpri/workspace/move3d/install/lib')
setenv('HOME_MOVE3D','/home/jmainpri/Dropbox/move3d/libmove3d')

% Set move3d and matlab working directories
move3d_dir = '/home/jmainpri/Dropbox/move3d/move3d-launch/';
matlab_dir = '/home/jmainpri/Dropbox/move3d/move3d-launch/matlab/';
move3d_data_dir = 'move3d_tmp_data_home/';

% Empty cache from move3d
cd( [matlab_dir 'move3d_tmp_data_home'] );
system('rm *txt');

% Add move3d matlab-commands to matlab path
addpath('/home/jmainpri/Dropbox/move3d/move3d-launch/matlab/move3d_matlab_commands');
addpath('/home/jmainpri/Dropbox/move3d/move3d-launch/matlab');

% Comment it with gui
use_gui = true;
if use_gui,
    gui_str='';
else
    gui_str='-nogui';
end

% Set move3d system-command, files and seed
move3d_cmd = ['move3d-qt-studio ' gui_str ' -launch SphereIOC -c pqp -f ../assets/IOC/Plane_Multi_squares.p3d -setgui -params ../move3d-launch/'];
file_params = 'parameters/params_spheres_ioc_squares';

% Fix seed
seed = 1391184849;

% Set the number of tests
nb_tests = 1;
% nb_tests = 5;

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
samples = 16*(1:10);
% samples = 16*100;

% Set move3d variables ----------------------------------------------------

move3d_set_variable( move3d_dir, file_params, 'stringParameter\\active_cost_function', 'costSquares' );
move3d_set_variable( move3d_dir, file_params, 'boolParameter\\init_spheres_cost', 'true' );
move3d_set_variable( move3d_dir, file_params, 'boolParameter\\ioc_single_iteration', 'false' );
move3d_set_variable( move3d_dir, file_params, 'boolParameter\\ioc_sample_around_demo', 'true' );
move3d_set_variable( move3d_dir, file_params, 'intParameter\\ioc_from_file_offset', '0' );
move3d_set_variable( move3d_dir, file_params, 'intParameter\\ioc_sample_iteration', '9' );

% -------------------------------------------------------------------------
% One test ----------------------------------------------------------------
% -------------------------------------------------------------------------

% move3d_set_variable( move3d_dir, file_params, 'boolParameter\\ioc_load_samples_from_file', 'true' );
% [results1, recovered_weights, feat_count, feat_jac] = ioc_single_test( move3d_dir, matlab_dir, move3d_cmd, file_params, ... 
%      seed, nb_tests, nb_demo, nb_features, samples  );
%  
% move3d_set_variable( move3d_dir, file_params, 'boolParameter\\ioc_load_samples_from_file', 'false' );
% [results2, recovered_weights, feat_count, feat_jac] = ioc_single_test( move3d_dir, matlab_dir, move3d_cmd, file_params, ... 
%      seed, nb_tests, nb_demo, nb_features, samples  );
%  
%  disp(['results1 : ' num2str( squeeze(results1)' )] )
%  disp(['results2 : ' num2str( squeeze(results2)' )] )
 
% -------------------------------------------------------------------------
% From file ---------------------------------------------------------------
% -------------------------------------------------------------------------

% move3d_set_variable( move3d_dir, file_params, 'boolParameter\\ioc_load_samples_from_file', 'true' );
% 
% [results, recovered_weights, feat_count, feat_jac] = ioc_single_test( move3d_dir, matlab_dir, move3d_cmd, file_params, ... 
%     seed, nb_tests, nb_demo, nb_features, samples  );
% 
% % plot_ioc_results_function( samples, results )
% % plot_weights( samples, recovered_weights )
% % plot_feature_gradient_sum( samples, feat_count )
% % plot_feature_gradient_sum( samples, feat_jac )
% 
% cd( matlab_dir );
% save('results_current/test_from_file.mat','results');
% save('results_current/weights_from_file.mat','recovered_weights');
% save('results_current/features_count_from_file.mat','feat_count');
% save('results_current/features_jac_from_file.mat','feat_jac');

% A = load('results_current/features_count_file.mat');
% plot_feature_gradient_sum( samples, A.feat_count );
% A = load('results_current/features_jac_from_file.mat');
% plot_feature_gradient_sum( samples, A.feat_jac );
% 
% A = load('results_current/feat_count_0_03_around_demo.mat');
% plot_feature_gradient_sum( samples, A.feat_count );
% A = load('results_current/feat_jac_0_03_around_demo.mat');
% plot_feature_gradient_sum( samples, A.feat_jac );
  
% -------------------------------------------------------------------------
% Random ------------------------------------------------------------------
% -------------------------------------------------------------------------

move3d_set_variable( move3d_dir, file_params, 'boolParameter\\ioc_load_samples_from_file', 'false' );

% -------------------------------------------------------------------------
% Call a serie of tests ---------------------------------------------------
% -------------------------------------------------------------------------

move3d_set_variable( move3d_dir, file_params, 'doubleParameter\\ioc_sample_std_dev', '0.05' );

[results, recovered_weights, feat_count, feat_jac] = ioc_single_test( move3d_dir, matlab_dir, move3d_data_dir, move3d_cmd, file_params, seed, nb_tests, nb_demo, nb_features, samples  );

% plot_ioc_results_function( samples, results )
% plot_weights( samples, recovered_weights )
% plot_feature_gradient_sum( samples, feat_count )
% plot_feature_gradient_sum( samples, feat_jac )

cd( matlab_dir );
save('results_current/test_0_05_monte_carlo.mat','results');
save('results_current/weights_0_05_monte_carlo.mat','recovered_weights');
save('results_current/feat_count_0_05_monte_carlo.mat','feat_count');
save('results_current/feat_jac_0_05_monte_carlo.mat','feat_jac');

% -------------------------------------------------------------------------

% move3d_set_variable( move3d_dir, file_params, 'doubleParameter\\ioc_sample_std_dev', '1.00' );
% 
% [results, recovered_weights, feat_count, feat_jac] = ioc_single_test( move3d_dir, matlab_dir, move3d_data_dir, move3d_cmd, file_params, ... 
%     seed, nb_tests, nb_demo, nb_features, samples  );
% 
% % plot_ioc_results_function( samples, results )
% % plot_weights( samples, recovered_weights )
% % plot_feature_gradient_sum( samples, feat_count )
% % plot_feature_gradient_sum( samples, feat_jac )
% 
% cd( matlab_dir );
% save('results_current/test_1_00_around_demo.mat','results');
% save('results_current/weights_1_00_around_demo.mat','recovered_weights');
% save('results_current/feat_count_1_00_around_demo.mat','feat_count');
% save('results_current/feat_jac_0_01_around_demo.mat','feat_jac');

% -------------------------------------------------------------------------

% move3d_set_variable( move3d_dir, file_params, 'doubleParameter\\ioc_sample_std_dev', '0.10' );
% 
% [results, recovered_weights, feat_count, feat_jac] = ioc_single_test( move3d_dir, matlab_dir, move3d_data_dir, move3d_cmd, file_params, ... 
%     seed, nb_tests, nb_demo, nb_features, samples  );
% 
% % plot_ioc_results_function( samples, results )
% % plot_weights( samples, recovered_weights )
% % plot_feature_gradient_sum( samples, feat_count )
% % plot_feature_gradient_sum( samples, feat_jac )
% 
% cd( matlab_dir );
% save('results_current/test_0_10_around_demo.mat','results');
% save('results_current/weights_0_10_around_demo.mat','recovered_weights');
% save('results_current/feat_count_0_10_around_demo.mat','feat_count');
% save('results_current/feat_jac_0_01_around_demo.mat','feat_jac');

% -------------------------------------------------------------------------

% move3d_set_variable( move3d_dir, file_params, 'doubleParameter\\ioc_sample_std_dev', '0.05' );
% 
% [results, recovered_weights, feat_count, feat_jac] = ioc_single_test( move3d_dir, matlab_dir, move3d_data_dir, move3d_cmd, file_params, ... 
%     seed, nb_tests, nb_demo, nb_features, samples  );
% % 
% % plot_ioc_results_function( samples, results )
% % plot_weights( samples, recovered_weights )
% % plot_feature_gradient_sum( samples, feat_count )
% % plot_feature_gradient_sum( samples, feat_jac )
% % 
% cd( matlab_dir );
% save('results_current/test_0_05_around_demo.mat','results');
% save('results_current/weights_0_05_around_demo_no_dominant.mat','recovered_weights');
% save('results_current/feat_count_0_05_around_demo.mat','feat_count');
% save('results_current/feat_jac_0_05_around_demo.mat','feat_jac');
% 
% var(feat_count{10}(2:end,:))
% mean(feat_count{10}(2:end,:))

% -------------------------------------------------------------------------

% move3d_set_variable( move3d_dir, file_params, 'doubleParameter\\ioc_sample_std_dev', '0.03' );
% 
% [results, recovered_weights, feat_count, feat_jac] = ioc_single_test( move3d_dir, matlab_dir, move3d_data_dir, move3d_cmd, file_params, ... 
%     seed, nb_tests, nb_demo, nb_features, samples  );
% % 
% % plot_ioc_results_function( samples, results )
% % plot_weights( samples, recovered_weights )
% % plot_feature_gradient_sum( samples, feat_count )
% % plot_feature_gradient_sum( samples, feat_jac )
% 
% cd( matlab_dir );
% save('results_current/test_0_03_around_demo.mat','results');
% save('results_current/weights_0_03_around_demo.mat','recovered_weights');
% save('results_current/feat_count_0_03_around_demo.mat','feat_count');
% % save('results_current/feat_jac_0_03_around_demo.mat','feat_jac');

% -------------------------------------------------------------------------

% move3d_set_variable( move3d_dir, file_params, 'doubleParameter\\ioc_sample_std_dev', '0.01' );
% 
% [results,recovered_weights, feat_count, feat_jac] = ioc_single_test( move3d_dir, matlab_dir, move3d_data_dir, move3d_cmd, file_params, ... 
%     seed, nb_tests, nb_demo, nb_features, samples  );
% % 
% % plot_ioc_results_function( samples, results )
% % plot_weights( samples, recovered_weights )
% % % plot_feature_gradient_sum( samples, feat_count )
% % % plot_feature_gradient_sum( samples, feat_jac )
% % 
% cd( matlab_dir );
% save('results_current/test_0_01_around_demo.mat','results');
% save('results_current/weights_0_01_around_demo.mat','recovered_weights');
% save('results_current/feat_count_0_01_around_demo.mat','feat_count');
% % save('results_current/feat_jac_1_00_around_demo.mat','feat_jac');

% -------------------------------------------------------------------------
% -------------------------------------------------------------------------

% move3d_set_variable( move3d_dir, file_params, 'boolParameter\\ioc_sample_around_demo', 'false' );

% -------------------------------------------------------------------------
% -------------------------------------------------------------------------

% move3d_set_variable( move3d_dir, file_params, 'doubleParameter\\ioc_sample_std_dev', '0.03' );
% 
% [results,recovered_weights, jacob_feat] = ioc_single_test( move3d_dir, matlab_dir, move3d_data_dir, move3d_cmd, file_params, ... 
%     seed, nb_tests, nb_demo, nb_features, samples  );
% 
% % plot_ioc_results_function( samples, results )
% % plot_weights( samples, recovered_weights )
% 
% cd( matlab_dir );
% save('results_current/test_0_03_straight_line.mat','results');
% save('results_current/weights_0_03_straight_line.mat','recovered_weights');

% -------------------------------------------------------------------------

% move3d_set_variable( move3d_dir, file_params, 'doubleParameter\\ioc_sample_std_dev', '0.05' );
% 
% [results,recovered_weights, jacob_feat] = ioc_single_test( move3d_dir, matlab_dir, move3d_data_dir, move3d_cmd, file_params, ... 
%     seed, nb_tests, nb_demo, nb_features, samples  );
% 
% % plot_ioc_results_function( samples, results )
% % plot_weights( samples, recovered_weights )
% 
% cd( matlab_dir );
% save('results_current/test_0_05_straight_line.mat','results');
% save('results_current/weights_0_05_straight_line.mat','recovered_weights');

% -------------------------------------------------------------------------

% move3d_set_variable( move3d_dir, file_params, 'doubleParameter\\ioc_sample_std_dev', '1.00' );
% 
% [results,recovered_weights, jacob_feat] = ioc_single_test( move3d_dir, matlab_dir, move3d_data_dir, move3d_cmd, file_params, ... 
%     seed, nb_tests, nb_demo, nb_features, samples  );
% 
% % plot_ioc_results_function( samples, results )
% % plot_weights( samples, recovered_weights )
% 
% cd( matlab_dir );
% save('results_current/test_1_00_straight_line.mat','results');
% save('results_current/weights_1_00_straight_line.mat','recovered_weights');
