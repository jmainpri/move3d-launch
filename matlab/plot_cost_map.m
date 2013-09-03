clear; clc;

load('cost_map.txt')
[X,Y] = meshgrid([-40:0.800001:40]);
Z = cost_map;
contour3(X,Y,Z,30)
surface(X,Y,Z,'EdgeColor',[.8 .8 .8],'FaceColor','none')
grid off
view(-15,25)
colormap cool

hold on
load('traj.txt')
plot(traj(2,:),traj(1,:));
