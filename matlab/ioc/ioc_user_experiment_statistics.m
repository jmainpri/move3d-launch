cd( matlab_dir );

% sephere
% w_0 = [ 1.0, 1.0, 1.0, 1.0, ...
%         1.0, 0.5, 0.08, 1.0, ...
%         1.0, 0.3, 0.5, 1.0, ...
%         1.0, 1.0, 1.0, 1.0, ...
%         ];

% human trajectories
w_0 = [0.00, 0.50, 0.20, 0.60, 1.00, 0.60, 0.30, 1.00, 0.20, 0.70, 0.60, 0.20, 0.20, 0.20, ...
    0.80, 0.80, 0.80, 0.90, 0.80, 0.80, 0.80, 0.50, 1.00, 0.90, 0.70, 0.10, 0.70, ...
    0.80, 0.80, 0.50, 0.30, 0.20, 0.20, 0.30, 0.20, 0.20, 1.00, 1.00, 1.00, 1.00, ... 
    1.00, 1.00, 0.80, 1.00, 1.00, 1.00, 0.50, 0.80, 0.80, 0.10 ];

w_16 =[ 0.01, 0.80, 0.50, 0.80, ...
        0.50, 0.20, 0.20, 0.50, ...
        0.50, 0.20, 0.50, 0.50, ...
        0.50, 0.50, 0.50, 0.20];

print_markers = false;

%% HUMANS
w_1 = [[1 1 1 1 1 1 1 1]  1 * w_16];

% w_1 = [[100] w_16];
print_markers = true;

with_replan = 'replan';

nb_demos = load(['results_current/tmp_results_' with_replan '/nb_demos_human_motion_' with_replan '_user_study.mat']);
features = load(['results_current/tmp_results_' with_replan '/feat_human_motion_' with_replan '_user_study.mat']);
weights  = load(['results_current/tmp_results_' with_replan '/weig_human_motion_' with_replan '_user_study.mat']);

%% -------------------------------------------------------------------------
size(weights.recovered_weights)
w_o = squeeze(weights.recovered_weights)';
%w_1(2) = 0
% w_1 = ones(size(w_1))

size_feature_data = size( features.feat_count{1} );
nb_of_feature_vector = size_feature_data(1);
nb_samples = ( nb_of_feature_vector / ( nb_demos.nb_demo ) ) - 1;

display(['nb of demo : ' num2str(nb_demos.nb_demo)]);

for i=1:nb_demos.nb_demo,
    
    % get feature values
    phi_demo = features.feat_count{1}(i,:);
    id_start = (i-1)*nb_samples+nb_demos.nb_demo+1;
    id_end = i*nb_samples+nb_demos.nb_demo;
    phi_samples = features.feat_count{1}(id_start:id_end,:);
    
    size(phi_samples)
    
    % print statistics
    print_stats( i, phi_demo, phi_samples, w_o, w_1, print_markers );
    
    w = waitforbuttonpress;
    
    if w == 0
        disp('Button click')
    else
        disp('Key press')
    end
    
    close
end