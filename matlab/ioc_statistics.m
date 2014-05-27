cd( matlab_dir );

clc

t = 10; % test
r = 1; % run
A = load('results_current/feat_count_1_00_around_demo.mat');

print_stats( A.feat_count{r,t}(1,:), A.feat_count{r,t}(2:end,:) );

t = 10; % test
r = 1; % run
A = load('results_current/feat_count_0_05_around_demo.mat');

print_stats( A.feat_count{r,t}(1,:), A.feat_count{r,t}(2:end,:) );

t = 10; % test
r = 1; % run
A = load('results_current/feat_count_0_03_around_demo.mat');

print_stats( A.feat_count{r,t}(1,:), A.feat_count{r,t}(2:end,:) );

t = 10; % test
r = 1; % run
A = load('results_current/feat_count_0_01_around_demo.mat');

print_stats( A.feat_count{r,t}(1,:), A.feat_count{r,t}(2:end,:) );

% t = 1; % test
% r = 1; % run
% A = load('results_current/feat_count_1_00_monte_carlo.mat');
% 
% print_stats( A.feat_count{r,t}(1,:), A.feat_count{r,t}(2:end,:) );

t = 1; % test
r = 1; % run
A = load('results_current/feat_count_0_05_monte_carlo.mat');

print_stats( A.feat_count{r,t}(1,:), A.feat_count{r,t}(2:end,:) );

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