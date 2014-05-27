clear; clc;

global phi_demo
global phi_k
global nb_used_samples

% iteration
i = 1;

% set variables
% phi_demo = [0.3 0.5 0.2];
phi_demo = [0.3 0.5];
nb_features = size(phi_demo,2);

% samples
phi_k = [];

% phi_k = [phi_k; [0.3 0.6 0.3]];
% phi_k = [phi_k; [0.9 0.3 0.4]];

phi_k = [phi_k; [0.3 0.6]];
phi_k = [phi_k; [0.9 0.3]];
phi_k = [phi_k; [0.01 0.90]];
phi_k = [phi_k; [0.10 0.75]];

% phi_k = [phi_k; [0.3 0.6]];
% phi_k = [phi_k; [0.9 0.3]];
% phi_k = [phi_k; [0.01 0.90]];
% phi_k = [phi_k; [0.10 0.75]];
% phi_k = [phi_k; [0.3 0.6]];
% phi_k = [phi_k; [0.9 0.3]];
% phi_k = [phi_k; [0.01 0.90]];
% phi_k = [phi_k; [0.10 0.75]];
% phi_k = [phi_k; [0.3 0.6]];
% phi_k = [phi_k; [0.9 0.3]];
% phi_k = [phi_k; [0.01 0.90]];
% phi_k = [phi_k; [0.10 0.75]];
% phi_k = [phi_k; [0.3 0.6]];
% phi_k = [phi_k; [0.9 0.3]];
% phi_k = [phi_k; [0.01 0.90]];
% phi_k = [phi_k; [0.10 0.75]];
% phi_k = [phi_k; [0.3 0.6]];
% phi_k = [phi_k; [0.9 0.3]];
% phi_k = [phi_k; [0.01 0.90]];
% phi_k = [phi_k; [0.10 0.75]];
% phi_k = [phi_k; [0.3 0.6]];
% phi_k = [phi_k; [0.9 0.3]];
% phi_k = [phi_k; [0.01 0.90]];
% phi_k = [phi_k; [0.10 0.75]];
% phi_k = [phi_k; [0.3 0.6]];
% phi_k = [phi_k; [0.9 0.3]];
% phi_k = [phi_k; [0.01 0.90]];
% phi_k = [phi_k; [0.10 0.75]];
% phi_k = [phi_k; [0.3 0.6]];
% phi_k = [phi_k; [0.9 0.3]];
% phi_k = [phi_k; [0.01 0.90]];
% phi_k = [phi_k; [0.10 0.75]];
% phi_k = [phi_k; [0.3 0.6]];
% phi_k = [phi_k; [0.9 0.3]];
% phi_k = [phi_k; [0.01 0.90]];
% phi_k = [phi_k; [0.10 0.75]];
% phi_k = [phi_k; [0.3 0.6]];
% phi_k = [phi_k; [0.9 0.3]];
% phi_k = [phi_k; [0.01 0.90]];
% phi_k = [phi_k; [0.10 0.75]];

% set variables
nb_used_samples = size(phi_k,1);
max = 1; % use 1
lb = zeros(1,nb_features);
ub = max*ones(1,nb_features);

% Execute constrainted minimization
w0 = zeros(1,nb_features);
[w,fval,exitflag,output,lambda,grad,hessian] = constrainted_minimization( w0, lb, ub );

% bar(w)

display(['weight 1 is : ' num2str(w(1))]);
display(['weight 2 is : ' num2str(w(2))]);
display(['cost for demo ' num2str(i) ' : ' num2str(w * phi_demo')]);

for i=1:nb_used_samples,
    display(['cost for sample ' num2str(i) ' : ' num2str(w * phi_k(i,:)')]);
end

% figure 

% Generate data to make a surface 
% x = -10:1:10;
% y = -10:1:10;
% [X,Y] = meshgrid(x,y);
% Z = exp( -X.*0.5 + -Y.*0.5 );
% % Z = Z + exp( -X.*phi_k(3,1) - Y.*phi_k(3,2) ) ;
% % Z = Z + exp( -X.*phi_k(4,1) - Y.*phi_k(4,2) ) ;
% % Z = Z + exp( -X.*phi_k(5,1) - Y.*phi_k(5,2) ) ;
% % Z = Z + exp( -X.*phi_k(6,1) - Y.*phi_k(6,2) ) ;
% % visualize 3D surface
% surf(X,Y,Z)
% %imagesc([Z]);