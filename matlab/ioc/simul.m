function [x,fval,exitflag,output] = simul(x0,lb,ub)
%% This is an auto generated MATLAB file from Optimization Tool.

%% Start with the default options
options = saoptimset;
%% Modify options setting
options = saoptimset(options,'AnnealingFcn', @annealingboltz);
options = saoptimset(options,'Display', 'off');
options = saoptimset(options,'HybridInterval', 'end');
options = saoptimset(options,'PlotFcns', { @saplotf });
[x,fval,exitflag,output] = ...
simulannealbnd(@cost_function,x0,lb,ub,options);
