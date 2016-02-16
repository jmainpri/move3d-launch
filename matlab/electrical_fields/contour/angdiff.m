%% Compute the angle difference
% between two 2D vectors theta1 - theta2
function dtheta = angdiff(theta1, theta2)
dtheta = atan2(sin(theta1-theta2), cos(theta1-theta2));