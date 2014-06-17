%clear; clc;
%close all hidden

% cost_map = load('cost_map_0.txt')
% cost_map = load('cost_map_64.txt');
% cost_map = load('matlab/cost_map_feat_64.txt');
% cost_map = load('matlab/cost_map_derv_1_64.txt');
% cost_map = load('matlab/cost_map_derv_1_64.txt');

% set heat map to be : redbluecmap(10000) or redgreencmap(10000)
% HeatMap(load('matlab/cost_map_64.txt'));
nb_colors = 1000;
formatSpec = '%03d';

% x = 0:0.01:5;
% y = exp(-x);
% plot(x,y);

cd( matlab_dir );

% plot the jacobian cost evoulition
for num=1:25,
    subplot(5,5,num);
    % run = 6*(num-1);
    run = num;
    filename = [['cost_maps/cost_jac_'] num2str(run,formatSpec) ['.txt']];
    display(['load : ' filename]);
    imagesc(load(filename),[0,1]);
    title(['Number : ' num2str(run,formatSpec)]);
    colorbar
end

% plot the jacobian cost evoulition
% for p=0:4,
%     for i=0:4,
%         subplot(5,5,5*(p)+i+1);
%         num = 160*p+i;
%         filename = [['cost_maps/cost_jac_'] num2str(num,formatSpec) ['.txt']];
%         display(['load : ' filename]);
%         imagesc(load(filename),[0,1]);
%         title(['Number : ' num2str(num,formatSpec)]);
%         colorbar
%     end
% end

% figure
% filename = [['cost_maps/cost_map_'] num2str(0,formatSpec) ['.txt']];
% display(['load : ' filename]);
% imagesc(load(filename),[0,1]);
% colorbar

% figure
% for i=0:15,
%     subplot(4,4,i+1);
%     filename = [['cost_maps/cost_map_feat_'] num2str(i,formatSpec) ['.txt']];
%     display(['load : ' filename]);
%     imagesc(load(filename),[0,1]);
% end
% 
% figure
% for i=0:15,
%     subplot(4,4,i+1);
%     filename = [['cost_maps/cost_map_'] num2str(i,formatSpec) ['.txt']];
%     display(['load : ' filename]);
%     imagesc(load(filename),[0,1]);
%     colorbar
% end

% figure
% for i=0:15,
%     subplot(4,4,i+1);
%     filename = [['cost_maps/cost_map_derv_0_'] num2str(i,formatSpec) ['.txt']];
%     display(['load : ' filename]);
%     imagesc(load(filename));
% end
% 
% figure
% for i=0:15,
%     subplot(4,4,i+1);
%     filename = [['cost_maps/cost_map_derv_1_'] num2str(i,formatSpec) ['.txt']];
%     display(['load : ' filename]);
%     imagesc(load(filename));
% end

% figure
% for i=0:15,
%     subplot(4,4,i+1);
%     filename = [['cost_maps/cost_map_jac_mag_simple_'] num2str(i,formatSpec) ['.txt']];
%     display(['load : ' filename]);
%     imagesc(load(filename));
% end

% h1 = plot( HeatMap( load('matlab/cost_map_64.txt'), 'Symmetric', false, 'Colormap', colormap(jet(nb_colors)) ));
% h2 = HeatMap( load('matlab/cost_map_feat_64.txt'), 'Symmetric', false, 'Colormap', colormap(jet(nb_colors)) );
% h3 = HeatMap( load('matlab/cost_map_derv_0_64.txt'), 'Symmetric', false, 'Colormap', colormap(jet(nb_colors)) );
% h4 = HeatMap( load('matlab/cost_map_derv_1_64.txt'), 'Symmetric', false, 'Colormap', colormap(jet(nb_colors)) );
% h5 = HeatMap( load('matlab/cost_map_jac_mag_simple.txt'), 'Symmetric', false, 'Colormap', colormap(jet(nb_colors)) );
% h6 = HeatMap( load('matlab/cost_map_jac_mag_custom.txt'), 'Symmetric', false, 'Colormap', colormap(jet(nb_colors)) );

% print(h1, '-dpng', '/home/jmainpri/Pictures/Labmeeting/24.01.14/cost_map_64.png');
% print(h2, '-dpng', '/home/jmainpri/Pictures/Labmeeting/24.01.14/cost_map_feat_64.png');
% print(h3, '-dpng', '/home/jmainpri/Pictures/Labmeeting/24.01.14/cost_map_derv_0_64.png');
% print(h4, '-dpng', '/home/jmainpri/Pictures/Labmeeting/24.01.14/cost_map_derv_1_64.png');
% print(h5, '-dpng', '/home/jmainpri/Pictures/Labmeeting/24.01.14/cost_map_jac_mag_simple.png');
% print(h6, '-dpng', '/home/jmainpri/Pictures/Labmeeting/24.01.14/cost_map_jac_mag_custom.png');

% figure
% 
% [X,Y] = meshgrid([-40:0.800001:40]);
% Z = cost_map;
% contour3(X,Y,Z,30)
% surface(X,Y,Z,'EdgeColor',[.8 .8 .8],'FaceColor','none')
% grid off
% Tcam = [135 -70];
% view(Tcam);
% colormap cool
% 
% hold on
% load('traj_0.txt')
% plot(traj_0(2,:),traj_0(1,:));