function costmapdemo

N = 5;
xMax = 0.10;
xMin = -0.10;
centers = (xMax-xMin) * rand(N,2) + xMin;

% scatter( centers(:,1), centers(:,2) );
% pause;

% axis([0 1 0 1])
% e = energy(centers(1,:), centers);

xMaxPlot = 0.5;
xMinPlot = -0.5;
[C] = costmap(centers, xMaxPlot, xMinPlot);
plot_field(C, xMaxPlot, xMinPlot);

% point is the querry point
% centers are the points where to compute the distance from
function e = energy( point, centers )

beta = 1.0;
gamma = 20.0;
p =  repmat(point, size(centers,1), 1);
dist = sqrt(sum((p - centers)' .^ 2))';
e = log( sum( exp( -dist/beta ) .^ gamma ) );
% e = max(e) / sum(e);

function plot_field( C, xMaxPlot, xMinPlot )

size(C)

NGrid = 50 ;% Number of grid points for plots
xMax = xMaxPlot; % Values plotted from x= -xMax to x= xMax
yMax = xMaxPlot; % Values plotted from y= -yMax to y= yMax

xPlot = zeros(1,NGrid); 
yPlot = zeros(1,NGrid);

for i=1:NGrid
    xPlot(i) = xMinPlot + (i-1)/(NGrid-1)*(2*xMax); % x values to plot
    yPlot(i) = xMinPlot + (i-1)/(NGrid-1)*(2*yMax); % y values to plot
end

VPlot  = zeros(NGrid, NGrid);
ExPlot = zeros(NGrid, NGrid);
EyPlot = zeros(NGrid, NGrid);

delta = 1e-6;

%@ Loop over all grid points and evaluate V(x,y) and E(x,y) on grid
for i=1:NGrid
    y = yPlot(i);
    
    for j=1:NGrid
        x = xPlot(j);
        
        %@ Compute potential at the grid point
        VPlot(i,j) = energy([x y], C);  % Potential V(x,y)
        %@ Compute components of the electric field
        ExPlot(i,j) = (energy([x+delta, y], C) - ...
            energy([x-delta y], C)) / 2*delta;
        EyPlot(i,j) = (energy([x, y+delta], C) - ...
            energy([x y-delta], C)) / 2*delta;
        
        %@ Normalize E-field vectors to unit length
        MagnitudeE = sqrt( ExPlot(i,j)^2 + EyPlot(i,j)^2 );
        ExPlot(i,j) = ExPlot(i,j)/MagnitudeE;
        EyPlot(i,j) = EyPlot(i,j)/MagnitudeE;
    end
end

%@ Plot contours of constant electric potential
% clf; figure(gcf); % Clear figure; bring figure window forward
% surf(xPlot,yPlot,VPlot); % Plot potential in contour/mesh plot
% shading interp
% xlabel('x'); ylabel('y'); zlabel('Potential');
% title('Strike any key to continue ...');
% pause;


% Specify contour levels used in contour plot
axis([-xMax xMax -yMax yMax]); % Fix the min,max for x,y axes
axis square
cs = contour(xPlot,yPlot,VPlot,15); % Draw contour plot
clabel(cs); % Place contour labels on contour levels
%@ Add electric field direction to potential contour plot
hold on;
% quiver(xPlot,yPlot,ExPlot,EyPlot); % Draw arrows for E field
% title('Potential contours and electric field direction');
% xlabel('x'); ylabel('y');

%[u v] = gradient(VPlot); 
streamslice(xPlot,yPlot,ExPlot,EyPlot);

hold on
plot(C(:,1), C(:,2),'b*');

hold off;

