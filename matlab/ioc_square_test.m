clear; clc

% Set the enviroment for move3d libraries
setenv('LD_LIBRARY_PATH','/home/jmainpri/openrobots/lib')

% Set move3d and matlab working directories
move3d_dir = '/home/jmainpri/workspace/move3d/move3d-launch/';
matlab_dir = '/home/jmainpri/workspace/move3d/move3d-launch/matlab/';

% Add move3d commands
cd( matlab_dir );
addpath('/home/jmainpri/workspace/move3d/move3d-launch/matlab/move3d_matlab_commands');

% Set move3d calls
move3d_cmd = 'move3d-qt-studio -launch SphereIOC -c pqp -f ../assets/IOC/Plane_Multi_squares.p3d -setgui -params ../move3d-launch/';
file_params = 'parameters/params_spheres_ioc_squares';
seed = 1391184849;

% Set local variables
nb_demo = 1;
nb_features = 16; % 64 + 1 (smoothness)
nb_sampling_phase = 20; % in c++ (move3d)
nb_samples = 100;
min_samples = 10;
max_samples = nb_samples;

% Set Learning parameters
init_factor = 0;

% Set the number of tests
nb_tests = 1;
results = zeros( nb_tests, nb_sampling_phase, 3 );

cd( move3d_dir );
move3d_set_variable( file_params, 'boolParameter\\ioc_exit_after_run', 'true' );
move3d_set_variable( file_params, 'boolParameter\\ioc_single_iteration', 'false' );
move3d_set_variable( file_params, 'boolParameter\\ioc_load_samples_from_file', 'false' );
move3d_set_variable( file_params, 'stringParameter\\active_cost_function', 'costSquares' );

for i=1:nb_tests,
    
    clc
    
    seed = seed + 1;
    
    disp('********************************************************')
    disp(['TEST : ', num2str(i)])
    disp('********************************************************')
    
    %waitforbuttonpress;

    % EXECUTE PHASE EVALUTAION (sampling)
    cd( move3d_dir );
    move3d_set_variable( file_params, 'intParameter\\ioc_phase', '1' ); 
    cmd = strcat( move3d_cmd, file_params );
    cmd = strcat( cmd, [' -s ' num2str(seed) ] );
    %display( cmd );
    system( cmd );
    
    % LEARNING PHASE EVALUTAION (optimization)
    cd( matlab_dir );
    ioc_learning( nb_demo, nb_features, nb_sampling_phase, nb_samples, min_samples, max_samples, init_factor );
    close
    
    % COMPARE WEIGHTS WITH PLANNING (compare)
    cd( move3d_dir );
    move3d_set_variable( file_params,'intParameter\\ioc_phase', '2' );
    cmd = strcat( move3d_cmd, file_params );
    %display( cmd );
    system( cmd);
    
    % LOAD RESULTS
    cd( matlab_dir );
    results(i,:,:) = load('data/result.txt');
%     plot(results(i,:,3))
end

cd( move3d_dir );
move3d_set_variable( file_params, 'boolParameter\\ioc_exit_after_run', 'false' );

samples = 1:nb_sampling_phase;
for i=0:nb_sampling_phase-1, 
    samples(i+1) = floor( min_samples + i*(max_samples-min_samples)/(nb_sampling_phase-1) );
end

close

if nb_tests > 1,
    plot(samples,mean(results(:,:,3)))
    hold on
    % errorbar(1:nb_tests,mean(results(:,:,3)),min(results(:,:,3)),max(results(:,:,3)))
    errorbar(samples,mean(results(:,:,3)),std(results(:,:,3)))
else
    plot(samples,results(:,:,3))
end
