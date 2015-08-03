clear; clc;
pwd

figure

% number of dofs
% PR2 : 7
% Human : 22
K = 6; 

% M is the number of rows
% N is the number of plots per row
M = 6;
N = K / M;
if mod(M,N) >= 1,
    N = N +1;
end


folder = '/jim_local/Dropbox/move3d/move3d-launch/launch_files/control_cost_profiles/';

for k=0:K-1,
    subplot(M,N,k+1)
    id = sprintf('%3.3d',k);
    file = [folder 'stomp_vel_' id '.txt'];
    display(['load : ' file]);
    mat = csvread(file);
    size(mat)
    % mat = csvread([folder 'stomp_acc_' id '.txt']);
    % mat = csvread([folder 'stomp_jerk_' id '.txt']);
    control_costs = mat;
    plot( control_costs );
    % title(['DOF ' id]);
    % axis([0 100 0 10])
end