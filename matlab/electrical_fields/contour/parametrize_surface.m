%% Parametrize a surface between 0 and 2 Pi
% returns two vector values (u and v)
% in 2D only one value (u) used
function [u,v] = parametrize_surface(C)
nb_points = size(C,1);
u = linspace(0, 2*pi, nb_points+1);
u = u(1:nb_points);
v = zeros(nb_points);