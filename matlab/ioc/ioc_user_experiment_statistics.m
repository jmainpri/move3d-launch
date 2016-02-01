cd( matlab_dir );

% sephere
% w_0 = [ 1.0, 1.0, 1.0, 1.0, ...
%         1.0, 0.5, 0.08, 1.0, ...
%         1.0, 0.3, 0.5, 1.0, ...
%         1.0, 1.0, 1.0, 1.0, ...
%         ];

% human trajectories
w_0 = [0.00, 0.50, 0.20, 0.60, 1.00, 0.60, 0.30, 1.00, 0.20, ...
    0.70, 0.60, 0.20, 0.20, 0.20, ...
    0.80, 0.80, 0.80, 0.90, 0.80, 0.80, 0.80, 0.50, 1.00, 0.90, ...
    0.70, 0.10, 0.70, ...
    0.80, 0.80, 0.50, 0.30, 0.20, 0.20, 0.30, 0.20, 0.20, 1.00, ...
    1.00, 1.00, 1.00, ... 
    1.00, 1.00, 0.80, 1.00, 1.00, 1.00, 0.50, 0.80, 0.80, 0.10 ];

w_16 =[ 0.01, 0.80, 0.50, 0.80, ...
        0.50, 0.20, 0.20, 0.50, ...
        0.50, 0.20, 0.50, 0.50, ...
        0.50, 0.50, 0.50, 0.20];
    
% Add the 12 dimension of the bio-kinematics
w_12 =[ 0.50, 0.50, 0.50, 0.50, ...
        0.50, 0.50, 0.50, 0.50, ...
        0.50, 0.50, 0.50, 0.50];


%% HUMANS
w_1 = [[1 1 1 1 1 1 1 1]  1 * w_16 1 * w_12];

% w_1 = [[100] w_16];
display = true;
print_markers = true;
with_replan = 'noreplan';
with_regularizer = true;
regularizer = 0.01;
% 0, 0.01, 0.05, 0.1, 0.5, 1, 5, 10, 50, 100
% REPLAN : 0.5 -> 9 %
% NO REPLAN : 0.01 -> 9%

if with_regularizer,
    nb_demos = load(['results_current/tmp_results_' ...
        with_replan '/nb_demos_human_motion_' with_replan '_user_study_'...
        num2str(regularizer) '_.mat']);
    features = load(['results_current/tmp_results_' ...
        with_replan '/feat_human_motion_' with_replan '_user_study_' ...
        num2str(regularizer) '_.mat']);
    weights  = load(['results_current/tmp_results_' ...
        with_replan '/weig_human_motion_' with_replan '_user_study_' ...
        num2str(regularizer) '_.mat']);
else
    nb_demos = load(['results_current/tmp_results_' ...
        with_replan '/nb_demos_human_motion_' with_replan '_user_study_' ...
        num2str(regularizer) '_.mat']);
    features = load(['results_current/tmp_results_' ...
        with_replan '/feat_human_motion_' with_replan '_user_study_' ...
        num2str(regularizer) '_.mat']);
    weights  = load(['results_current/tmp_results_' ...
        with_replan '/weig_human_motion_' with_replan '_user_study_' ...
        num2str(regularizer) '_.mat']);
end

%ids = ['spheres_features_demo_ids_', ...
%    num2str(nb_samples,formatSpec), '.txt'];

%% ------------------------------------------------------------------------
% Get basic data out of the mat structures

size(weights.recovered_weights)
w_o = squeeze(weights.recovered_weights)';
%w_1(2) = 0
% w_1 = ones(size(w_1))

size_feature_data = size( features.feat_count{1} );
nb_of_feature_vector = size_feature_data(1);
nb_samples = ( nb_of_feature_vector / ( nb_demos.nb_demo ) ) - 1;

% TODO this does not work for the no replan ...
% nb_samples = 300 should use the ids to compute this
if strcmp(with_replan, 'replan'),
    w_o = w_o';
    nb_demo = nb_demos.nb_demo;
else
    nb_samples = 300;
    nb_demo = 461;
end

%% ------------------------------------------------------------------------
% Save the w vector to text file for the validation phase
% you then have to move the files to the tmp_weights folder to use them

csvwrite( [matlab_dir 'move3d_tmp_data_human_trajs/' ...
        'user_study_' with_replan '_spheres_weights_' ...
        num2str(nb_samples,'%03d'), ...
        '_', num2str(regularizer), '_.txt'], w_o );
    
w_o

%% ------------------------------------------------------------------------
disp(['nb of demo : ' num2str(nb_demos.nb_demo)]);
disp(['nb of samples : ' num2str(nb_samples)]);

total_number_degen = 0;

for d=1:nb_demos.nb_demo,
    
    % get feature values
    phi_demo = features.feat_count{1}(d,:);
    id_start = (d-1)*nb_samples+(nb_demo+1);
    id_end = d*nb_samples+nb_demo;
    phi_samples = features.feat_count{1}(id_start:id_end,:);
    
    % print statistics
    number_of_degeneration = print_stats( d, phi_demo, phi_samples, ...
        w_o, w_1, print_markers, display );
    
    disp(['number of degenration : ' num2str(number_of_degeneration)])
    
    % compute the dotal number of degeneration
    total_number_degen = total_number_degen + number_of_degeneration;
    
    if( display ),
        w = waitforbuttonpress;
    end
    if w == 0
        disp('Button click')
    else
        disp('Key press')
    end
    
    close
end

disp('****************************');
disp(['total_number_degen : ' num2str(total_number_degen)])
disp(['percent number_degen : ' ...
    num2str(100*total_number_degen/(nb_demos.nb_demo*nb_samples))])
