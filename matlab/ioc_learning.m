function ioc_learning( nb_demo, nb_features, samples, init_factor )

global phi_demo
global phi_k
global nb_used_samples

% w = zeros(1,nb_features);
% cost_function(w)
% w = ones(1,nb_features);
% cost_function(w)

max = 1;
lb = zeros(1,nb_features);
ub = max*ones(1,nb_features);

% Use constrainted minimization
use_constrainted_minimization = 1;

% iteration
i = 1;

% Multiple instance with difference sizes of samples
for s=samples,
    
    % Can set number of used sample to be less than present in file
    nb_used_samples = s;
    
    % Load file
    [phi_demo, phi_k] = load_instance( nb_demo, s, nb_features );
    
    if use_constrainted_minimization == 1 ,
        % Execute constrainted minimization
        w0 = init_factor*ones(1,nb_features);
        [w,fval,exitflag,output,lambda,grad,hessian] = constrainted_minimization( w0, lb, ub );
    else
        % Execute genetic algorithm
        Generations_Data = 2000;
        TolFun_Data = 1e-12;
        TolFun_Data = 0;
        [w,fval,exitflag,output,population,score] = genetic_algo( nb_features, lb, ub, Generations_Data, TolFun_Data );
    end
    
    disp('---------------------------------------')
    disp(['finshed with iteration : ', num2str(i)])
    disp(['nb of samples : ', num2str(s,'%03d')])

    disp(['fval : ', num2str(fval)])
    disp('optimization done!!!');

    % Saving to file
    disp('writing weights to file');
    csvwrite(['move3d_tmp_data/spheres_weights_', num2str(s,'%03d'), '.txt'],w);
    
    % Increment iteration
    i = i + 1;
end
