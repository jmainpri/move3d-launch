clear; clc;

%cost_map = load('cost_map_0.txt')
cost_map = load('cost_map.txt')
[X,Y] = meshgrid([-40:0.800001:40]);
Z = cost_map;
contour3(X,Y,Z,30)
surface(X,Y,Z,'EdgeColor',[.8 .8 .8],'FaceColor','none')
grid off
Tcam = [135 -70];
view(Tcam);
colormap cool

hold on
load('traj_0.txt')
plot(traj_0(2,:),traj_0(1,:));

hold on
load('traj.txt')
plot(traj(2,:),traj(1,:));