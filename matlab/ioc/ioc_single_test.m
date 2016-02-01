function [ nb_demo, nb_feature, results, weights, feat_count, feat_jac] = ioc_single_test( move3d_dir, matlab_dir, move3d_data_dir, move3d_cmd, file_params, ... 
    seed, nb_tests, samples, phases, demo_id  )

% Folder where move3d stores data
% data_folder = 'move3d_tmp_data_home/';
data_folder = move3d_data_dir;

global ioc_regularizer;

if( phases(1) == true ),
    % Set move3d basic parameters
    move3d_set_variable( move3d_dir, file_params, 'boolParameter\\ioc_exit_after_run', 'true' );
    % move3d_set_variable( move3d_dir, file_params, 'boolParameter\\ioc_single_iteration', 'false' );

    % Get number of demos and number of features from move3d
    move3d_set_variable( move3d_dir, file_params, 'intParameter\\ioc_phase', '7' ); % save_feature_and_demo_size
    move3d_set_variable( move3d_dir, file_params, 'boolParameter\\ioc_single_iteration', 'true' );
end

if( phases(1) == true ),
    cd( move3d_dir );
    system( strcat( move3d_cmd, file_params ) );
    cd( matlab_dir );
    prob = load('problem.txt');
    if ~isequal(size(prob), [2 1]),
        error('problem size not loaded correctly!!!')
    end
    nb_demo = prob(1);
    nb_feature = prob(2);
    display(['Number of demos ' num2str(nb_demo)])
    
    move3d_set_variable( move3d_dir, file_params, 'boolParameter\\ioc_single_iteration', 'false' );
      
else
   nb_demo = 7;
   nb_feature = 36;
end
  
% Init result struct
nb_runs = size(samples,2); % number of phases
results = zeros( nb_tests, nb_runs, 6 );
weights = zeros( nb_tests, nb_runs, nb_feature );
feat_count = cell( nb_tests, nb_runs );
feat_jac = cell( nb_tests, nb_runs );
    
% Set Learning parameters
init_factor = 0.5;

sampling = phases(1);
learning = phases(2);
compare = phases(3);

for i=1:nb_tests,
    
%     clc
    
    seed = seed + 1;
    
    disp('********************************************************')
    disp(['TEST : ', num2str(i)])
    disp('********************************************************')

    if sampling,
        % EXECUTE PHASE (sampling)
        % set offset to -1 for random tests
        move3d_set_variable( move3d_dir, file_params, 'intParameter\\ioc_from_file_offset', num2str((i-1)*160) );
        move3d_set_variable( move3d_dir, file_params, 'intParameter\\ioc_phase', '1' ); % WARNING set to one for normal sampling
        cd( move3d_dir );
        cmd = strcat( move3d_cmd, file_params );
        cmd = strcat( cmd, [' -s ' num2str(seed) ] );
        %display( cmd );
        system( cmd );
    end
    
    if learning,
        % LEARNING PHASE (optimization)
        cd( matlab_dir );
        ioc_learning( nb_demo, nb_feature, samples, init_factor, data_folder, demo_id );
        close
    end
    
    if compare,
        % COMPARE PLANNING TO DEMONSTRATION (compare)
        move3d_set_variable( move3d_dir, file_params,'intParameter\\ioc_phase', '2' );
        cd( move3d_dir );
        cmd = strcat( move3d_cmd, file_params );
        cmd = strcat( cmd, [' -s ' num2str(seed) ] );
        %display( cmd );
        system( cmd);

        % LOAD RESULTS
        cd( matlab_dir );
        if nb_tests == 1 && nb_runs == 1,
            results(i,:) = load([data_folder 'result.txt']);
        end
        results(i,:,:,:,:) = load([data_folder 'result.txt']);
    end
    
    matlab_dir
    cd( matlab_dir );
    for r=1:size(samples,2),
        weights(i,r,:) = load([data_folder 'spheres_weights_', ...
            num2str(samples(r),'%03d'), '_', num2str(ioc_regularizer), '_.txt']);
        feat_count(i,r) = { load([data_folder 'spheres_features_', ...
            num2str(samples(r),'%03d'), '.txt']) };
        % feat_jac(i,r) = { load([data_folder 'spheres_jac_sum_', num2str(samples(r),'%03d'), '.txt']) };
    end
end

if sampling,
    cd( move3d_dir );
    move3d_set_variable( move3d_dir, file_params, 'boolParameter\\ioc_exit_after_run', 'false' );
    move3d_set_variable( move3d_dir, file_params, 'intParameter\\ioc_phase', '-1' );
end