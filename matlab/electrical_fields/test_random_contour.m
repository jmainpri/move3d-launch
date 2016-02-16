function test_random_contour()

clc
close all; %clear all;

% Control the shape of the object with the seed
seed = 1004;
rng(seed)

%-------------------------------------------------------------------------%
% 1) get costmap and contour
nb_of_centers = 7;
xMax = 0.10;
xMin = -0.10;
xMaxArea = 1;
xMinArea = -1;
centers = (xMax-xMin) * rand(nb_of_centers,2) + xMin;
figure(1)
fh1 = figure(1);
set(fh1, 'color', 'white')
[contour] = costmap(centers, xMaxArea, xMinArea );
xMaxPlot = 0.3;
xMinPlot = -0.3;
xlabel('x-axis in meters','fontsize',14);
ylabel('y-axis in meters','fontsize',14);
plot( contour(:,1), contour(:,2) );
plot( contour(:,1), contour(:,2), 'x' );
axis([xMinPlot xMaxPlot xMinPlot xMaxPlot]);
axis square
test_contour_valid(contour);

%-------------------------------------------------------------------------%
% 1) test coutour
function test_contour_valid(c)
if c(1,:) == c(end,:) ,
    error('no good init and end');
end
for i = 1:(size(c,1)-1),
    if c(i,:) == c(i+1,:),
        error('no good');
    end
end

disp('everything ok');