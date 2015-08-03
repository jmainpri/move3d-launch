function [x,fval,exitflag,output,lambda,grad,hessian] = constrainted_minimization(x0,lb,ub)
%% This is an auto generated MATLAB file from Optimization Tool.

%% Start with the default options
options = optimset;
%% Modify options setting
options = optimset(options,'Display', 'on');
options = optimset(options,'FunValCheck', 'on');
% uncomment next line to plot weights
options = optimset(options,'PlotFcns', { @optimplotx });
options = optimset(options,'Algorithm', 'active-set');
options = optimset(options,'GradObj', 'on');
[x,fval,exitflag,output,lambda,grad,hessian] = ...
fmincon(@cost_function_and_gradient,x0,[],[],[],[],lb,ub,[],options);
