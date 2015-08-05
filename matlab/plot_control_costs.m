clear; clc;
pwd

figure

% number of dofs
% PR2 : 7
% Human : 22
% Stones : 2
K = 7; 

% M is the number of rows
% N is the number of plots per row
M = 3; % 6
N = floor(K / M);
if mod(M,N) >= 1,
    N = N +1;
end

folder = '/jim_local/Dropbox/move3d/move3d-launch/launch_files/control_cost_profiles/';

for k=0:K-1,
    subplot(M,N,k+1)
    id = sprintf('%3.3d',k);
    file = [folder 'stomp_vel_' id '.csv'];
    %file = [folder 'stomp_acc_' id '.csv'];
    %file = [folder 'stomp_jerk_' id '.csv'];
    display(['load : ' file]);
    mat = csvread(file);
    size(mat)
    control_costs = mat;
    plot( control_costs );
    % title(['DOF ' id]);
    % axis([0 100 0 10])
end