clear; clc

% Set the enviroment for move3d libraries
setenv('LD_LIBRARY_PATH','/home/jmainpri/openrobots/lib')

% Set move3d and matlab working directories
move3d_dir = '/home/jmainpri/workspace/move3d/move3d-launch';
matlab_dir = '/home/jmainpri/workspace/move3d/move3d-launch/matlab';

% Set move3d calls
move3d_cmd = 'move3d-qt-studio -nogui -launch SphereIOC -c pqp -f ../assets/IOC/Plane_Multi.p3d -setgui';
sample_params = ' -params ../move3d-launch/parameters/params_spheres_ioc';
compare_params = ' -params ../move3d-launch/parameters/params_spheres_ioc_compare';

% Set local variables
nb_demo = 1;
nb_features = 64; % 64 + 1 (smoothness)
nb_sampling_phase = 20; % in c++ (move3d)
nb_samples = 100;
min_samples = 2;
max_samples = nb_samples;

% Set Learning parameters
init_factor = 0.5;

% Set the number of tests
nb_tests = 6*50;
results = zeros( nb_tests, nb_sampling_phase, 3 );

for i=1:nb_tests,
    
    clc
    
    disp('********************************************************')
    disp(['TEST : ', num2str(i)])
    disp('********************************************************')
    
    %waitforbuttonpress;

    cd( move3d_dir );
    system( strcat( move3d_cmd, sample_params ));
    
    cd( matlab_dir );
    ioc_learning( nb_demo, nb_features, nb_sampling_phase, nb_samples, min_samples, max_samples, init_factor );
    close
    
    cd( move3d_dir );
    system( strcat( move3d_cmd, compare_params ));
    
    cd( matlab_dir );
    results(i,:,:) = load('data/result.txt');
%     plot(results(i,:,3))
    
end

close
plot(mean(results(:,:,3)))
hold on
% errorbar(1:nb_tests,mean(results(:,:,3)),min(results(:,:,3)),max(results(:,:,3)))
errorbar(1:nb_sampling_phase,mean(results(:,:,3)),std(results(:,:,3)))