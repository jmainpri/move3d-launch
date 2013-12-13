clear; clc

global phi_demo
global phi_k
global nb_used_samples

nb_demo = 1;
nb_features = 64; % 64 + 1 (smoothness)
nb_samples = 100;
nb_used_samples = nb_samples;
nb_sampling_phase = 50; % in c++ (move3d)
min_samples = 3;
max_samples = nb_samples;

% w = zeros(1,nb_features);
% cost_function(w)
% w = ones(1,nb_features);
% cost_function(w)

max = 1;
lb = zeros(1,nb_features);
ub = max*ones(1,nb_features);

% Use constrainted minimization
use_constrainted_minimization = 1;

% Multiple instance
for i=1:(nb_sampling_phase-1), 
    
    nb_samples = floor( min_samples + i*(max_samples-min_samples)/(nb_sampling_phase-1) );
    nb_used_samples = nb_samples;
    
    % Load file
    [phi_demo, phi_k] = load_instance( nb_demo, nb_samples, nb_features );
    
    if use_constrainted_minimization == 1 ,
        % Execute constrainted minimization
        w0 = 0.5*ones(1,nb_features);
        [w,fval,exitflag,output,lambda,grad,hessian] = constrainted_minimization( w0, lb, ub );
    else
        % Execute genetic algorithm
        Generations_Data = 2000;
        TolFun_Data = 1e-12;
        TolFun_Data = 0;
        [w,fval,exitflag,output,population,score] = genetic_algo( nb_features, lb, ub, Generations_Data, TolFun_Data );
    end
    
    disp(['---------------------------------------'])
    disp(['finshed with iteration : ', num2str(i)])

    disp(['fval : ', num2str(fval)])
    disp('optimization done!!!');

    % Saving to file
    disp('writing weights to file');
    csvwrite(['data/spheres_weights_', num2str(nb_samples,'%03d'), '.txt'],w);
end
