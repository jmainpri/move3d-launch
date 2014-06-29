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

clc

w_16 =[ 0.01, 0.80, 0.50, 0.80, ...
        0.50, 0.20, 0.20, 0.50, ...
        0.50, 0.20, 0.50, 0.50, ...
        0.50, 0.50, 0.50, 0.20];

w_1 = [[0.8]  1 * w_16];

t = 1; % test (id)
r = 1; % run (sampling phase)
features = load('results_current/feat_human_motion.mat');
weights = load('results_current/weights_human_motion.mat');

w_1 = squeeze(weights.recovered_weights(t,r,:))';
%w_1(2) = 0
% w_1 = ones(size(w_1))

size_feature_data = size( features.feat_count{t,r} )
nb_of_feature_vector = size_feature_data(1);
nb_samples = ( nb_of_feature_vector / ( nb_demo ) ) - 1;
    
for i=1:nb_demo,
    phi_demo = features.feat_count{r,t}(i,:);
    id_start = (i-1)*nb_samples+nb_demo+1;
    id_end = i*nb_samples+nb_demo+1;
    phi_samples = features.feat_count{r,t}(id_start:id_end,:);
    print_stats( i, phi_demo, phi_samples, w_1 );
    
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