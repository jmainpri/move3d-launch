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

w_1 = [[0.7]  1 * w_16];

t = 1; % test
r = 1; % run
features = load('results_current/feat_human_motion.mat');
weights = load('results_current/weights_human_motion.mat');

w_1 = squeeze(weights.recovered_weights(1,t,:))'
%w_1(2) = 0
% w_1 = ones(size(w_1))

print_stats( features.feat_count{r,t}(1,:), features.feat_count{r,t}(2:end,:), w_1 );


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