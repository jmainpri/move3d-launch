% e_and_v - Compute electric field from potential
% and graph potential contours and E-field direction
clear all; help e_and_v; % Clear memory; print header
%@ Initialize variables (e.g., potential V(x,y), graphics)
fprintf('Enter potential V(x,y) as an equation \n');
%fprintf('For example: log(x^2 + y^2) \n');
%V = input(': ','s'); % Read in V(x,y) as text string
NGrid = 20; % Number of grid points for plots
xMax = 5; % Values plotted from x= -xMax to x= xMax
yMax = xMax; % Values plotted from y= -yMax to y= yMax
%20-4
%V
for i=1:NGrid
    xPlot(i) = -xMax + (i-1)/(NGrid-1)*(2*xMax); % x values to plot
    yPlot(i) = -yMax + (i-1)/(NGrid-1)*(2*yMax); % y values to plot
end

%@ Evaluate electric field as Ex = (-1)*dV/dx and Ey = (-1)*dV/dy
% Note use of symop command to perform symbolic multiplication by -1
% Ex = symop( '-1', '*', diff(V,'x') );
% Ey = symop( '-1', '*', diff(V,'y') );
% fprintf('Electric field components are \n');
% disp(['x component : ', Ex]);
% disp(['y component : ', Ey]);

%@ Loop over all grid points and evaluate V(x,y) and E(x,y) on grid
for i=1:NGrid
    y = yPlot(i);
    for j=1:NGrid
        
        x = xPlot(j);
        
        %@ Compute potential at the grid point
        VPlot(i,j) = log(x^2 + y^2);  % Potential V(x,y)
        %@ Compute components of the electric field
        ExPlot(i,j) = 2*x / (y^2 + x^2);
        EyPlot(i,j) = 2*y / (y^2 + x^2);
        
        %@ Normalize E-field vectors to unit length
        MagnitudeE = sqrt( ExPlot(i,j)^2 + EyPlot(i,j)^2 );
        ExPlot(i,j) = ExPlot(i,j)/MagnitudeE;
        EyPlot(i,j) = EyPlot(i,j)/MagnitudeE;
    end
end

%@ Plot contours of constant electric potential
clf; figure(gcf); % Clear figure; bring figure window forward
meshc(xPlot,yPlot,VPlot); % Plot potential in contour/mesh plot
xlabel('x'); ylabel('y'); zlabel('Potential');
title('Strike any key to continue ...');
pause;
% Specify contour levels used in contour plot
axis([-xMax xMax -yMax yMax]); % Fix the min,max for x,y axes
cs = contour(xPlot,yPlot,VPlot); % Draw contour plot
clabel(cs); % Place contour labels on contour levels
%@ Add electric field direction to potential contour plot
hold on;
quiver(xPlot,yPlot,ExPlot,EyPlot); % Draw arrows for E field
title('Potential contours and electric field direction');
xlabel('x'); ylabel('y');
hold off;