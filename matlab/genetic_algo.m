function [x,fval,exitflag,output,population,score] = genetic_algo(nvars,lb,ub,Generations_Data,TolFun_Data)
%% This is an auto generated MATLAB file from Optimization Tool.

%% Start with the default options
options = gaoptimset;
%% Modify options setting
options = gaoptimset(options,'Generations', Generations_Data);
options = gaoptimset(options,'TolFun', TolFun_Data);
options = gaoptimset(options,'Display', 'off');
options = gaoptimset(options,'PlotFcns', { @gaplotbestf });
[x,fval,exitflag,output,population,score] = ...
ga(@cost_function,nvars,[],[],[],[],lb,ub,[],[],options);
