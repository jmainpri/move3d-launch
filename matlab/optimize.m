clear; clc

m = load('features.txt');

global phi_demo
global phi_k
global nb_used_samples

nb_samples = 1000;
nb_demo = 10;

nb_used_samples = 10;

phi_demo = m(1:nb_demo,:);
phi_k = zeros(nb_samples,16,nb_demo);

for d=1:nb_demo,
    phi_k(:,:,d) = m(((d-1)*nb_samples+(nb_demo+1)):(d*nb_samples+nb_demo),:);
end

w = zeros(1,16);
cost_function(w)
w = ones(1,16);
cost_function(w)

%-------------------------------------------
%-------------------------------------------
max = 100;
lb = [0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0];
ub = [max max max max max max max max max max max max max max max max];

%-------------------------------------------
%-------------------------------------------

Generations_Data = 2000;
%TolFun_Data = 1e-12;
TolFun_Data = 0;
genetic_algo(16,lb,ub,Generations_Data,TolFun_Data)

%-------------------------------------------
%-------------------------------------------

% x0 = [1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1];
% w = constrainted_minimization(x0,lb,ub);

%-------------------------------------------
%-------------------------------------------

disp('optimization done!!!');

%-------------------------------------------
%-------------------------------------------
disp('writing weights to file');
csvwrite('weights.csv',w);
