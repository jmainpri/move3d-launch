function test_charged_segment()

NGrid = 100 ;% Number of grid points for plots
xMax = 1.0; % Values plotted from x= -xMax to x= xMax
yMax = 1.0; % Values plotted from y= -yMax to y= yMax
xMin = -1.0;
yMin = -1.0;

xPlot = zeros(1,NGrid); 
yPlot = zeros(1,NGrid);

for i=1:NGrid
    xPlot(i) = xMin + (i-1)/(NGrid-1)*(2*xMax); % x values to plot
    yPlot(i) = yMin + (i-1)/(NGrid-1)*(2*yMax); % y values to plot
end

VPlot  = zeros(NGrid, NGrid);

close all

p0 = [.3 -.2];
p1 = [.2 -.8];

VMax = 10;

for i=1:NGrid
    y = yPlot(i);
    
    for j=1:NGrid
        x = xPlot(j);
        
        %@ Compute potential at the grid point
        VPlot(i,j) = potential_charged_segment_oriented(...
            p0,p1,[x y]);
        
        % Cutoff
        if VPlot(i,j) > VMax,
            VPlot(i,j) = VMax;
        end
    end
end

% Specify contour levels used in contour plot
surf(xPlot,yPlot,VPlot)
shading interp
axis([xMin xMax yMin yMax]); % Fix the min,max for x,y axes
view(-360,90); axis tight, axis square
xlabel('x-axis in nb of data points','fontsize',14);
ylabel('y-axis in nb of data points','fontsize',14);
hold on
scatter3( ...
    p1(1), p1(2), ...
    interp2(xPlot,yPlot,VPlot,p0(1),p0(2)), ...
     'MarkerEdgeColor','k',...
     'MarkerFaceColor',[0 .75 .75]); % blue
 scatter3( ...
    p0(1), p0(2), ...
    interp2(xPlot,yPlot,VPlot,p1(1),p1(2)), ...
     'MarkerEdgeColor','k',...
     'MarkerFaceColor',[.75 0 .75]); % red




