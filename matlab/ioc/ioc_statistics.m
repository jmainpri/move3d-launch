move3d_base_dir = '/usr/local/jim_local/Dropbox/move3d/';
move3d_dir = [move3d_base_dir 'move3d-launch/'];
matlab_dir = [move3d_dir 'matlab/'];

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

t = 1; % test (id)
r = 1; % run (sampling phase)

% Add the 12 dimension of the bio-kinematics
w_12 =[ 0.50, 0.50, 0.50, 0.50, ...
        0.50, 0.50, 0.50, 0.50, ...
        0.50, 0.50, 0.50, 0.50];


%% HUMANS
w_1 = [[1 1 1 1 1 1 1 1]  1 * w_16 1 * w_12];

% Original Motions
loo_splits =[];
loo_splits = [loo_splits ; '[0444-0585]'];
loo_splits = [loo_splits ; '[0446-0578]'];
loo_splits = [loo_splits ; '[0489-0589]'];
loo_splits = [loo_splits ; '[0525-0657]'];
loo_splits = [loo_splits ; '[0780-0871]'];
loo_splits = [loo_splits ; '[1537-1608]'];
loo_splits = [loo_splits ; '[2711-2823]'];

% w_1 = [[100] w_16];
ith = 7;
split = loo_splits(ith,:);
print_markers = true;

with_replan = 'noreplan';

nb_demos = load(['results_current/tmp_results_' with_replan ...
    '/nb_demos_human_motion_' with_replan '_' split '.mat']);
features = load(['results_current/tmp_results_' with_replan ...
    '/feat_human_motion_' with_replan '_' split '.mat']);
weights  = load(['results_current/tmp_results_' with_replan ...
    '/weig_human_motion_' with_replan '_' split '.mat']);

% features = load(['results_current/tmp_results_replan/feat_human_motion_replan_' split '.mat']);
% weights = load(['results_current/tmp_results_replan/weig_human_motion_replan_' split '.mat']);

%% 3 SPHERES
% w_1 = [0.3 1.0 0.5];
% features = load('results_current/feat_count_spheres.mat');
% weights = load('results_current/weights_spheres.mat');

%% 16 SQUARES / SPHERES
% w_1 = [1.000 1.000 1.000 1.000 1.000 0.500 0.080 1.000 1.000 0.300 0.500 1.000 1.000 1.000 1.000 1.000];
% features = load('results_current/feat_count_spheres.mat');
% weights = load('results_current/weights_spheres.mat');

%% 64 SPHERES
% w_1 = [0.080 0.080 0.080 0.080 0.080 0.080 0.080 0.080 0.080 0.010 0.010 0.010 0.020 0.010 0.010 0.400 1.000 1.000 1.000 0.600 0.500 0.060 0.010 0.400 1.000 1.000 0.500 0.300 0.010 0.010 0.010 0.500 1.000 0.010 0.050 0.050 0.500 1.000 1.000 1.000 0.080 0.010 0.300 0.990 0.990 1.000 1.000 1.000 0.500 0.010 0.010 0.010 0.030 0.010 0.010 0.100 1.000 1.000 0.120 0.100 0.100 0.100 0.120 0.100];
% features = load('results_current/feat_count_spheres.mat');
% weights = load('results_current/weights_spheres.mat');

%% -------------------------------------------------------------------------

display = true;

w_o = squeeze(weights.recovered_weights(t,r,:))';
%w_1(2) = 0
% w_1 = ones(size(w_1))

size_feature_data = size( features.feat_count{t,r} );
nb_of_feature_vector = size_feature_data(1);
nb_samples = ( nb_of_feature_vector / ( nb_demos.nb_demo ) ) - 1;

% TODO this does not work for the no replan ...
% nb_samples = 300 should use the ids to compute this

nb_demos.nb_demo

if strcmp(with_replan, 'replan'),
    w_o = w_o;
    nb_demo = nb_demos.nb_demo;
    nb_samples = 330;
else
    nb_samples = 330;
    nb_demo = 7;
end

%% ------------------------------------------------------------------------
% Save the w vector to text file for the validation phase
% you then have to move the files to the tmp_weights folder to use them

csvwrite( [matlab_dir 'move3d_tmp_data_human_trajs/' ...
        'user_study_' with_replan '_spheres_weights_' ...
        num2str(nb_samples,'%03d'), ...
        '_', split, '_.txt'], w_o );

disp(['nb of demo : ' num2str(nb_demos.nb_demo)]);
disp(['nb of samples : ' num2str(nb_samples)]);


for i=1:nb_demos.nb_demo,
    
    % get feature values
    phi_demo = features.feat_count{t,r}(i,:);
    id_start = (i-1)*nb_samples+nb_demos.nb_demo+1;
    id_end = i*nb_samples+nb_demo;
    phi_samples = features.feat_count{t,r}(id_start:id_end,:);
    
    % print statistics
    print_stats( i, phi_demo, phi_samples, w_o, w_1, ...
        print_markers, display);
    
    w = waitforbuttonpress;
    
    if w == 0
        disp('Button click')
    else
        disp('Key press')
    end
    
    close
end

% -------------------------------------------------------------------------

%w_1_recovered = squeeze(weights.recovered_weights(t,r,:))';

% TEST DEMOS
% w_1_weights = [[0.8]  1 * w_16];
% w_1_recovered = squeeze(weights.recovered_weights(t,r,:))';
% 
% figure
% subplot(2,1,1)
% bar( w_1_weights )
% axis([0 18 0 1])
% title('Weights')
% subplot(2,1,2)
% bar( w_1_recovered )
% axis([0 18 0 1])

% -------------------------------------------------------------------------

% t = 10; % test
% r = 1; % run
% A = load('results_current/feat_count_1_00_around_demo.mat');
% 
% print_stats( A.feat_count{r,t}(1,:), A.feat_count{r,t}(2:end,:) );

% t = 10; % test
% r = 1; % run
% A = load('results_current/feat_count_0_05_around_demo.mat');
% 
% print_stats( A.feat_count{r,t}(1,:), A.feat_count{r,t}(2:end,:) );

% t = 10; % test
% r = 1; % run
% A = load('results_current/feat_count_0_03_around_demo.mat');
% 
% print_stats( A.feat_count{r,t}(1,:), A.feat_count{r,t}(2:end,:) );

% t = 10; % test
% r = 1; % run
% A = load('results_current/feat_count_0_01_around_demo.mat');
% 
% print_stats( A.feat_count{r,t}(1,:), A.feat_count{r,t}(2:end,:) );

% t = 1; % test
% r = 1; % run
% A = load('results_current/feat_count_1_00_monte_carlo.mat');
% 
% print_stats( A.feat_count{r,t}(1,:), A.feat_count{r,t}(2:end,:) );

% t = 1; % test
% r = 1; % run
% A = load('results_current/feat_count_0_05_monte_carlo.mat');
% 
% print_stats( A.feat_count{r,t}(1,:), A.feat_count{r,t}(2:end,:) );

% t = 10; % test
% r = 1; % run
% A = load('results_current/feat_count_0_01_around_demo.mat');
% 
% print_stats( A.feat_count{r,t}(1,:), A.feat_count{r,t}(2:end,:) );

% t = 10; % test
% r = 1; % run
% A = load('results_current/features_count_from_file.mat');
% 
% print_stats( A.feat_count{r,t}(1,:), A.feat_count{r,t}(2:end,:) );