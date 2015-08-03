clear; clc

% Set the enviroment for move3d libraries
setenv('LD_LIBRARY_PATH','/jim_local/move3d/install/lib:/home/jmainpri/catkin_ws/devel/lib:/opt/ros/groovy/lib')
setenv('HOME_MOVE3D','/jim_local/Dropbox/move3d/libmove3d')

% Set move3d and matlab working directories
move3d_dir = '/jim_local/Dropbox/move3d/move3d-launch/';
matlab_dir = [move3d_dir 'matlab/'];
ioc_dir = [matlab_dir 'ioc/'];
move3d_data_dir = 'move3d_tmp_data_human_trajs/';

% Empty cache from move3d
cd( [matlab_dir 'move3d_tmp_data_home'] );
system('rm *txt');

% Add move3d matlab-commands to matlab path
addpath([matlab_dir 'ioc']);
addpath([matlab_dir 'move3d_matlab_commands]']);

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

if use_sept,

    move3d_scenario_feb = '-sc ../assets/Collaboration/SCENARIOS/collaboration_test_mocap_resized.sce';
    file_params_feb = 'parameters/params_collaboration_planning_mocap';

    % Original Motions
    loo_splits = [loo_splits ; '[0444-0585]'];
    loo_splits = [loo_splits ; '[0446-0578]'];
    loo_splits = [loo_splits ; '[0489-0589]'];
    loo_splits = [loo_splits ; '[0525-0657]'];
    loo_splits = [loo_splits ; '[0780-0871]'];
    loo_splits = [loo_splits ; '[1537-1608]'];
    loo_splits = [loo_splits ; '[2711-2823]'];
    
    move3d_scenario = move3d_scenario_feb;
    file_params = file_params_feb;

end

if use_feb,
    
    % Active ICRA Deadline
    
    move3d_scenario_aterm = '-sc ../assets/Collaboration/SCENARIOS/collaboration_aterm.sce';
    file_params_aterm = 'params_collaboration_planning_aterm';

    loo_splits = [loo_splits ; '[0649-0740]'];
    loo_splits = [loo_splits ; '[1282-1370]'];
    loo_splits = [loo_splits ; '[1593-1696]'];
    loo_splits = [loo_splits ; '[1619-1702]'];
    loo_splits = [loo_splits ; '[1696-1796]'];
    
    move3d_scenario = move3d_scenario_aterm;
    file_params = file_params_aterm;

end

%% MOVE3D COMMAND
% Set move3d system-command, files and seed

move3d_cmd = ['move3d-qt-studio ' gui_str ' -launch SphereIOC -c pqp -f ../assets/Collaboration/TwoHumansTableMocap.p3d ' move3d_scenario ' -setgui -params ../move3d-launch/'];
    
%% IOC PARAMETERS
% Fix seed
seed = 1391184850;
% seed = seed + round(100000*rand());

% Set the number of tests
nb_tests = 1; % number of calls to each sampling phase

% Get samples sequence
samples = [700];
csvwrite( [matlab_dir, move3d_data_dir, 'samples_tmp.txt'], samples );

phases(1) = false; % sampling
phases(2) = true; % learning
phases(3) = false; % compare

compute_weight_vectors = true;
compute_trajectories = false;
compute_baseline = true;

% Set move3d variables ----------------------------------------------------

move3d_set_variable( move3d_dir, file_params, 'intParameter\\ioc_ik', '0' ); % 0 : no ik, 1 : only ik, 2 : both
move3d_set_variable( move3d_dir, file_params, 'stringParameter\\active_cost_function', 'costHumanTrajectoryCost' );
move3d_set_variable( move3d_dir, file_params, 'stringParameter\\ioc_traj_split_name', '' );
move3d_set_variable( move3d_dir, file_params, 'boolParameter\\ioc_use_baseline', 'false' );
move3d_set_variable( move3d_dir, file_params, 'boolParameter\\init_spheres_cost', 'false' );
move3d_set_variable( move3d_dir, file_params, 'boolParameter\\init_human_trajectory_cost', 'true' );
move3d_set_variable( move3d_dir, file_params, 'boolParameter\\ioc_single_iteration', 'false' );
move3d_set_variable( move3d_dir, file_params, 'boolParameter\\ioc_sample_around_demo', 'true' );
move3d_set_variable( move3d_dir, file_params, 'boolParameter\\ioc_draw_demonstrations', 'false' );
move3d_set_variable( move3d_dir, file_params, 'boolParameter\\ioc_draw_samples', 'false' );
move3d_set_variable( move3d_dir, file_params, 'intParameter\\ioc_from_file_offset', '0' );
move3d_set_variable( move3d_dir, file_params, 'boolParameter\\ioc_load_samples_from_file', 'false' );
move3d_set_variable( move3d_dir, file_params, 'doubleParameter\\ioc_sample_std_dev', '0.0001' );

move3d_set_variable( move3d_dir, file_params, 'drawTrajVector', 'false' );
move3d_set_variable( move3d_dir, file_params, 'drawTraj', 'true' );

%% ------------------------------------------------------------------------
%% GENERATE WEIGHT VECTORS REPLAN  ----------------------------------------
%% ------------------------------------------------------------------------

demo_id = -1;

if compute_weight_vectors,
    for i=1:size(loo_splits),
        
        move3d_set_variable( move3d_dir, file_params, 'boolParameter\\ioc_split_motions', 'true' );
        move3d_set_variable( move3d_dir, file_params, 'stringParameter\\ioc_traj_split_name' , loo_splits(i,:) );
        move3d_set_variable( move3d_dir, file_params, 'boolParameter\\ioc_remove_split' , 'true' );
        
        move3d_set_variable( move3d_dir, file_params, 'stringParameter\\ioc_traj_split_name' , loo_splits(i,:) );
        
        % when no sampling is performed load from a single file
        % by removing the unnecssary data
        if( phases(1) == false ),
            demo_id = i-1;
        end
        
        [nb_demo, nb_feature, results, recovered_weights, feat_count, feat_jac] = ioc_single_test( move3d_dir, matlab_dir, ...
            move3d_data_dir, move3d_cmd, file_params, seed, nb_tests, samples, phases, demo_id );
        
        cd( matlab_dir );
        
        save(['results_current/tmp_results_replan/nb_demos_human_motion_replan_' loo_splits(i,:) '.mat'],'nb_demo');
        save(['results_current/tmp_results_replan/resu_human_motion_replan_' loo_splits(i,:) '.mat'],'results');
        save(['results_current/tmp_results_replan/feat_human_motion_replan_' loo_splits(i,:) '.mat'],'feat_count');
        save(['results_current/tmp_results_replan/weig_human_motion_replan_' loo_splits(i,:) '.mat'],'recovered_weights');
        
        cd( ioc_dir );
    end
end

%% ------------------------------------------------------------------------
%% GENERATE WEIGHT VECTORS NO REPLAN  -------------------------------------
%% ------------------------------------------------------------------------

demo_id = -1;

if compute_weight_vectors,
    for i=1:size(loo_splits),
        
        move3d_set_variable( move3d_dir, file_params, 'boolParameter\\ioc_split_motions', 'false' );
        move3d_set_variable( move3d_dir, file_params, 'stringParameter\\ioc_traj_split_name' , loo_splits(i,:) );
        move3d_set_variable( move3d_dir, file_params, 'boolParameter\\ioc_remove_split' , 'true' );
        move3d_set_variable( move3d_dir, file_params, 'stringParameter\\ioc_traj_split_name' , loo_splits(i,:) );
        
        % when no sampling is performed load from a single file
        % by removing the unnecssary data
        if( phases(1) == false ),
            demo_id = i-1;
        end
        
        [nb_demo, nb_feature, results, recovered_weights, feat_count, feat_jac] = ioc_single_test( move3d_dir, matlab_dir, ...
            move3d_data_dir, move3d_cmd, file_params, seed, nb_tests, samples, phases, demo_id  );
        
        cd( matlab_dir );
        
        save(['results_current/tmp_results_noreplan/nb_demos_human_motion_noreplan_' loo_splits(i,:) '.mat'],'nb_demo');
        save(['results_current/tmp_results_noreplan/resu_human_motion_noreplan_' loo_splits(i,:) '.mat'],'results');
        save(['results_current/tmp_results_noreplan/feat_human_motion_noreplan_' loo_splits(i,:) '.mat'],'feat_count');
        save(['results_current/tmp_results_noreplan/weig_human_motion_noreplan_' loo_splits(i,:) '.mat'],'recovered_weights');
        
        cd( ioc_dir );
        
    end
end

%% ------------------------------------------------------------------------
%% ERASE AND CREATE FOLDERS -----------------------------------------------
%% ------------------------------------------------------------------------

if compute_trajectories,
    
    cd([matlab_dir move3d_data_dir 'tmp_trajs']);
    
    system('rm -r *')
    mkdir('replan');
    mkdir('noreplan');
    
    % SIX TEST FOLDER
    
    cd('replan');
    mkdir('baseline0');
    mkdir('baseline1');
    mkdir('recovered');
    
    cd('..');
    
    cd('noreplan');
    mkdir('baseline0');
    mkdir('baseline1');
    mkdir('recovered');
    
end


%% ------------------------------------------------------------------------
%% RUN STOMP NOREPLAN -----------------------------------------------------
%% ------------------------------------------------------------------------

if compute_trajectories,
    for i=1:size(loo_splits),
        
        % EXECUTE PHASE
        cd( move3d_dir );
        move3d_set_variable( move3d_dir, file_params, 'boolParameter\\ioc_no_replanning', 'true' );
        move3d_set_variable( move3d_dir, file_params, 'boolParameter\\ioc_use_baseline', 'false' );
        move3d_set_variable( move3d_dir, file_params, 'boolParameter\\ioc_split_motions', 'false' );
        move3d_set_variable( move3d_dir, file_params, 'stringParameter\\ioc_traj_split_name' , loo_splits(i,:) );
        move3d_set_variable( move3d_dir, file_params, 'intParameter\\ioc_phase', '6' ); % WARNING set to one for normal sampling
        move3d_set_variable( move3d_dir, file_params, 'boolParameter\\ioc_exit_after_run', 'true' );
        cmd = strcat( move3d_cmd, file_params );
        cmd = strcat( cmd, [' -s ' num2str(seed) ] );
        %display( cmd );
        system( cmd );
        
        % MOVE FILES
        cd([matlab_dir move3d_data_dir 'tmp_trajs/']);
        mkdir(['noreplan/recovered/' loo_splits(i,:)]);
        movefile('*traj',['noreplan/recovered/' loo_splits(i,:)]);
    end
end

%% ------------------------------------------------------------------------
%% RUN STOMP BASELINE CONSERVATIVE NOREPLAN -------------------------------
%% ------------------------------------------------------------------------

if compute_trajectories && compute_baseline,
    for i=1:size(loo_splits),
        
        % EXECUTE PHASE
        cd( move3d_dir );
        move3d_set_variable( move3d_dir, file_params, 'boolParameter\\ioc_no_replanning', 'true' );
        move3d_set_variable( move3d_dir, file_params, 'boolParameter\\ioc_use_baseline', 'true' );
        move3d_set_variable( move3d_dir, file_params, 'boolParameter\\ioc_conservative_baseline', 'true' );
        move3d_set_variable( move3d_dir, file_params, 'boolParameter\\ioc_split_motions', 'false' );
        move3d_set_variable( move3d_dir, file_params, 'stringParameter\\ioc_traj_split_name' , loo_splits(i,:) );
        move3d_set_variable( move3d_dir, file_params, 'intParameter\\ioc_phase', '6' ); % WARNING set to one for normal sampling
        move3d_set_variable( move3d_dir, file_params, 'boolParameter\\ioc_exit_after_run', 'true' );
        cmd = strcat( move3d_cmd, file_params );
        cmd = strcat( cmd, [' -s ' num2str(seed) ] );
        %display( cmd );
        system( cmd );
        
        % MOVE FILES
        cd([matlab_dir move3d_data_dir 'tmp_trajs/']);
        mkdir(['noreplan/baseline1/' loo_splits(i,:)]);
        movefile('*traj',['noreplan/baseline1/' loo_splits(i,:)]);
    end
end

%% ------------------------------------------------------------------------
%% RUN STOMP BASELINE AGRESSIVE NOREPLAN ----------------------------------
%% ------------------------------------------------------------------------

if compute_trajectories && compute_baseline,
    for i=1:size(loo_splits),
        
        % EXECUTE PHASE
        cd( move3d_dir );
        move3d_set_variable( move3d_dir, file_params, 'boolParameter\\ioc_no_replanning', 'true' );
        move3d_set_variable( move3d_dir, file_params, 'boolParameter\\ioc_use_baseline', 'true' );
        move3d_set_variable( move3d_dir, file_params, 'boolParameter\\ioc_conservative_baseline', 'false' );
        move3d_set_variable( move3d_dir, file_params, 'boolParameter\\ioc_split_motions', 'false' );
        move3d_set_variable( move3d_dir, file_params, 'stringParameter\\ioc_traj_split_name' , loo_splits(i,:) );
        move3d_set_variable( move3d_dir, file_params, 'intParameter\\ioc_phase', '6' ); % WARNING set to one for normal sampling
        move3d_set_variable( move3d_dir, file_params, 'boolParameter\\ioc_exit_after_run', 'true' );
        cmd = strcat( move3d_cmd, file_params );
        cmd = strcat( cmd, [' -s ' num2str(seed) ] );
        %display( cmd );
        system( cmd );
        
        % MOVE FILES
        cd([matlab_dir move3d_data_dir 'tmp_trajs/']);
        mkdir(['noreplan/baseline0/' loo_splits(i,:)]);
        movefile('*traj',['noreplan/baseline0/' loo_splits(i,:)]);
    end
end

%% ------------------------------------------------------------------------
%% RUN STOMP REPLAN -------------------------------------------------------
%% ------------------------------------------------------------------------

if compute_trajectories,
    for i=1:size(loo_splits),
        
        % EXECUTE PHASE
        cd( move3d_dir );
        move3d_set_variable( move3d_dir, file_params, 'boolParameter\\ioc_no_replanning', 'false' );
        move3d_set_variable( move3d_dir, file_params, 'boolParameter\\ioc_use_baseline', 'false' );
        move3d_set_variable( move3d_dir, file_params, 'boolParameter\\ioc_split_motions', 'false' );
        move3d_set_variable( move3d_dir, file_params, 'stringParameter\\ioc_traj_split_name' , loo_splits(i,:) );
        move3d_set_variable( move3d_dir, file_params, 'intParameter\\ioc_phase', '6' ); % WARNING set to one for normal sampling
        move3d_set_variable( move3d_dir, file_params, 'boolParameter\\ioc_exit_after_run', 'true' );
        cmd = strcat( move3d_cmd, file_params );
        cmd = strcat( cmd, [' -s ' num2str(seed) ] );
        %display( cmd );
        system( cmd );
        
        % MOVE FILES
        cd([matlab_dir move3d_data_dir 'tmp_trajs/']);
        mkdir(['replan/recovered/' loo_splits(i,:)]);
        movefile('*traj',['replan/recovered/' loo_splits(i,:)]);
    end
end

%% ------------------------------------------------------------------------
%% RUN STOMP BASELINE CONSERVATIVE REPLAN ---------------------------------
%% ------------------------------------------------------------------------

if compute_trajectories && compute_baseline,
    for i=1:size(loo_splits),
        % EXECUTE PHASE
        cd( move3d_dir );
        move3d_set_variable( move3d_dir, file_params, 'boolParameter\\ioc_no_replanning', 'false' );
        move3d_set_variable( move3d_dir, file_params, 'boolParameter\\ioc_use_baseline', 'true' );
        move3d_set_variable( move3d_dir, file_params, 'boolParameter\\ioc_conservative_baseline', 'true' );
        move3d_set_variable( move3d_dir, file_params, 'boolParameter\\ioc_split_motions', 'false' );
        move3d_set_variable( move3d_dir, file_params, 'stringParameter\\ioc_traj_split_name' , loo_splits(i,:) );
        move3d_set_variable( move3d_dir, file_params, 'intParameter\\ioc_phase', '6' ); % WARNING set to one for normal sampling
        move3d_set_variable( move3d_dir, file_params, 'boolParameter\\ioc_exit_after_run', 'true' );
        cmd = strcat( move3d_cmd, file_params );
        cmd = strcat( cmd, [' -s ' num2str(seed) ] );
        %display( cmd );
        system( cmd );
        
        % MOVE FILES
        cd([matlab_dir move3d_data_dir 'tmp_trajs/']);
        mkdir(['replan/baseline1/' loo_splits(i,:)]);
        movefile('*traj',['replan/baseline1/' loo_splits(i,:)]);
    end
end

%% ------------------------------------------------------------------------
%% RUN STOMP BASELINE AGRESSIVE REPLAN ------------------------------------
%% ------------------------------------------------------------------------

if compute_trajectories && compute_baseline,
    for i=1:size(loo_splits),
        
        % EXECUTE PHASE
        cd( move3d_dir );
        move3d_set_variable( move3d_dir, file_params, 'boolParameter\\ioc_no_replanning', 'false' );
        move3d_set_variable( move3d_dir, file_params, 'boolParameter\\ioc_use_baseline', 'true' );
        move3d_set_variable( move3d_dir, file_params, 'boolParameter\\ioc_conservative_baseline', 'false' );
        move3d_set_variable( move3d_dir, file_params, 'boolParameter\\ioc_split_motions', 'false' );
        move3d_set_variable( move3d_dir, file_params, 'stringParameter\\ioc_traj_split_name' , loo_splits(i,:) );
        move3d_set_variable( move3d_dir, file_params, 'intParameter\\ioc_phase', '6' ); % WARNING set to one for normal sampling
        move3d_set_variable( move3d_dir, file_params, 'boolParameter\\ioc_exit_after_run', 'true' );
        cmd = strcat( move3d_cmd, file_params );
        cmd = strcat( cmd, [' -s ' num2str(seed) ] );
        %display( cmd );
        system( cmd );
        
        % MOVE FILES
        cd([matlab_dir move3d_data_dir 'tmp_trajs/']);
        mkdir(['replan/baseline0/' loo_splits(i,:)]);
        movefile('*traj',['replan/baseline0/' loo_splits(i,:)]);
    end
end

