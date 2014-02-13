function results = ioc_single_test( move3d_dir, matlab_dir, move3d_cmd, file_params, seed, nb_tests, nb_demo, nb_features, samples  )

% Init result struct
results = zeros( nb_tests, size(samples,2), 4 );

% Set Learning parameters
init_factor = 0;

% Set move3d basic parameters
move3d_set_variable( move3d_dir, file_params, 'boolParameter\\ioc_exit_after_run', 'true' );
move3d_set_variable( move3d_dir, file_params, 'boolParameter\\ioc_single_iteration', 'false' );

for i=1:nb_tests,
    
    clc
    
    seed = seed + 1;
    
    disp('********************************************************')
    disp(['TEST : ', num2str(i)])
    disp('********************************************************')

    % EXECUTE PHASE (sampling)
    cd( move3d_dir );
    move3d_set_variable( move3d_dir, file_params, 'intParameter\\ioc_phase', '1' ); 
    cmd = strcat( move3d_cmd, file_params );
    cmd = strcat( cmd, [' -s ' num2str(seed) ] );
    %display( cmd );
    system( cmd );
    
    % LEARNING PHASE (optimization)
    cd( matlab_dir );
    ioc_learning( nb_demo, nb_features, samples, init_factor );
    close
    
    % COMPARE PLANNING TO DEMONSTRATION (compare)
    cd( move3d_dir );
    move3d_set_variable( move3d_dir, file_params,'intParameter\\ioc_phase', '2' );
    cmd = strcat( move3d_cmd, file_params );
    %display( cmd );
    system( cmd);
    
    % LOAD RESULTS
    cd( matlab_dir );
    results(i,:,:,:,:) = load('move3d_tmp_data/result.txt');
end

cd( move3d_dir );
move3d_set_variable( move3d_dir, file_params, 'boolParameter\\ioc_exit_after_run', 'false' );
move3d_set_variable( move3d_dir, file_params, 'intParameter\\ioc_phase', '-1' );
