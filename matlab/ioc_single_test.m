function [ results, weights, feat_count, feat_jac] = ioc_single_test( move3d_dir, matlab_dir, move3d_data_dir, move3d_cmd, file_params, ... 
    seed, nb_tests, nb_demo, nb_features, samples  )

% Folder where move3d stores data
% data_folder = 'move3d_tmp_data_home/';
data_folder = move3d_data_dir;

% Init result struct
nb_runs = size(samples,2);
results = zeros( nb_tests, nb_runs, 4 );
weights = zeros( nb_tests, nb_runs, nb_features );
feat_count = cell( nb_tests, nb_runs );
feat_jac = cell( nb_tests, nb_runs );

% Set Learning parameters
init_factor = 0;

% Set move3d basic parameters
move3d_set_variable( move3d_dir, file_params, 'boolParameter\\ioc_exit_after_run', 'true' );
% move3d_set_variable( move3d_dir, file_params, 'boolParameter\\ioc_single_iteration', 'false' );

for i=1:nb_tests,
    
    clc
    
    seed = seed + 1;
    
    disp('********************************************************')
    disp(['TEST : ', num2str(i)])
    disp('********************************************************')

    % EXECUTE PHASE (sampling)
    % set offset to -1 for random tests
    move3d_set_variable( move3d_dir, file_params, 'intParameter\\ioc_from_file_offset', num2str((i-1)*160) );
    move3d_set_variable( move3d_dir, file_params, 'intParameter\\ioc_phase', '1' ); % WARNING set to one for normal sampling
    cd( move3d_dir );
    cmd = strcat( move3d_cmd, file_params );
    cmd = strcat( cmd, [' -s ' num2str(seed) ] );
    %display( cmd );
    system( cmd );
    
    % LEARNING PHASE (optimization)
    cd( matlab_dir );
    ioc_learning( nb_demo, nb_features, samples, init_factor, data_folder );
    close
    
    % COMPARE PLANNING TO DEMONSTRATION (compare)
    move3d_set_variable( move3d_dir, file_params,'intParameter\\ioc_phase', '2' );
    cd( move3d_dir );
    cmd = strcat( move3d_cmd, file_params );
    %display( cmd );
    system( cmd);
    
    % LOAD RESULTS
    cd( matlab_dir );
    if nb_tests == 1 && nb_runs == 1,
        results(i,:) = load([data_folder 'result.txt']);
    end
    results(i,:,:,:,:) = load([data_folder 'result.txt']);
    for r=1:size(samples,2),
        weights(i,r,:) = load([data_folder 'spheres_weights_', num2str(samples(r),'%03d'), '.txt']);
        feat_count(i,r) = { load([data_folder 'spheres_features_', num2str(samples(r),'%03d'), '.txt']) };
        % feat_jac(i,r) = { load([data_folder 'spheres_jac_sum_', num2str(samples(r),'%03d'), '.txt']) };
    end
end

cd( move3d_dir );
move3d_set_variable( move3d_dir, file_params, 'boolParameter\\ioc_exit_after_run', 'false' );
move3d_set_variable( move3d_dir, file_params, 'intParameter\\ioc_phase', '-1' );
