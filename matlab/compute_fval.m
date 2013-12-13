clear; clc

global phi_demo
global phi_k
global nb_used_samples

nb_demo = 1;
nb_features = 64; % 64 + 1 (smoothness)
nb_samples = 100;
nb_used_samples = nb_samples;
nb_sampling_phase = 20; % in c++ (move3d)
min_samples = 3;
max_samples = 100;

lb = zeros(1,nb_features);
ub = ones(1,nb_features);

% Use constrainted minimization
use_constrainted_minimization = 1;

% File formating
formatSpec = '%03d';

% Multiple instance
for i=1:(nb_sampling_phase-1), 
    
    disp('---------------------------');
    
    nb_samples = floor( min_samples + i*(max_samples-min_samples)/(nb_sampling_phase-1) );
    nb_used_samples = nb_samples;
    
    % Load features
    [phi_demo, phi_k] = load_instance( nb_demo, nb_samples, nb_features );

    % Load weights for constrainted optimization
    filename = ['data_co_2/spheres_weights_', num2str(nb_samples,formatSpec), '.txt'];
    %display(filename)
    w = load(filename);
    [loss,dw] = cost_function_and_gradient(w);

    disp(['fval(co) : ', num2str(loss)])
    
    % Compute Genetic Algorithm
    filename = ['data_ga/spheres_weights_', num2str(nb_samples,formatSpec), '.txt'];
    %display(filename)
    w = load(filename);
    [loss,dw] = cost_function_and_gradient(w);

    disp(['fval(ga) : ', num2str(loss)])
end