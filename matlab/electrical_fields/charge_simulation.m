function charge_simulation()

addpath('contour/');

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

xMaxPlot = 0.5;
xMinPlot = -0.5;
axis([xMinPlot xMaxPlot xMinPlot xMaxPlot]);
xlabel('x-axis in meters','fontsize',14);
ylabel('y-axis in meters','fontsize',14);

%-------------------------------------------------------------------------%
% 2) get parametrized surface and draw normals
nb_of_normals = 30;
draw_length = xMaxPlot / 10;
[u,v] = parametrize_surface(contour);
hold on
plot( contour(:,1), contour(:,2) );
axis square;
u_draw = linspace(0, 2*pi, nb_of_normals);
for i=1:size(u_draw,2)-1,
    u_p = u_draw(i);
    [barycenter, normal] = get_barycenter_and_normal( u_p, u, contour);
    draw_arrow( [barycenter(1), barycenter(1)+draw_length*normal(1)], ...
        [barycenter(2), barycenter(2)+draw_length*normal(2)], ...
        {'Color','b','LineWidth', 1});
    plot( barycenter(1), barycenter(2), ...
        'Color', get_color(u_p/(2*pi)), 'Marker','o');
end

%-------------------------------------------------------------------------%
% 3) perform the charge simulation method (CSM)
nb_of_charges = 200;
use_point_charge = true;

[q, points] = simulate_charge( ... 
    u, contour, nb_of_charges, use_point_charge );
figure(2)
hold on
plot( contour(:,1), contour(:,2) );
axis([xMinPlot xMaxPlot xMinPlot xMaxPlot]), axis square;
xlabel('x-axis in meters','fontsize',14);
ylabel('y-axis in meters','fontsize',14);
for i=1:size(q),
    q_color = (q(i)-min(q))/(max(q)-min(q));
    plot( points(i,1), points(i,2), ...
        'Color', get_color( q_color ), 'Marker','o');
end
fh2 = figure(2);
set(fh2, 'color', 'white')

display(['minimal charge : ' num2str(min(q))])
display(['maximal charge : ' num2str(max(q))])

%-------------------------------------------------------------------------%
% 4) plot fields
% q = 1e-5 * ones(size(q));
u_t = linspace( 0, 2*pi, nb_of_charges+1 );
segments = get_segments( u, contour, u_t );
plot_field( ...
    contour, points, q, u, ...
    xMaxPlot, xMinPlot, use_point_charge, segments )

%% Plot Field
function plot_field( ...
    C, points, charges, u, ... 
    xMaxPlot, xMinPlot, use_point_charge, segments )

hold on

NGrid = 200; % Number of grid points for plots
xMax = xMaxPlot; % Values plotted from x= -xMax to x= xMax
yMax = xMaxPlot; % Values plotted from y= -yMax to y= yMax

x = zeros(1,NGrid);
y = zeros(1,NGrid);

for i=1:NGrid
    x(i) = xMinPlot + (i-1)/(NGrid-1)*(2*xMax); % x values to plot
    y(i) = xMinPlot + (i-1)/(NGrid-1)*(2*yMax); % y values to plot
end


% charges'
compute_grid = false;

if compute_grid,
    
    V  = zeros(NGrid, NGrid);
    
    %@ Loop over all grid points and evaluate V(x,y) and E(x,y) on grid
    for i=1:NGrid
        for j=1:NGrid
            %@ Compute potential at the grid point
            % Potential V(x,y)
            if use_point_charge,
                
                V(i,j) = potential_at_point_from_point_charges( ...
                    [x(i) y(j)], points, charges );
            else
                V(i,j) = potential_at_point_from_segments( ...
                    [x(i) y(j)], segments, charges );
            end
        end
    end
    save( 'V.mat', 'V', 'x', 'y', 'C', 'u' );
else
    data = load('V.mat');
    V = data.V;
end
%@ Compute gradient
V = V';
[Ex, Ey] = gradient(V);
Ex = -Ex;
Ey = -Ey;

% Electric field Magnitude
E = sqrt(Ex.^2+Ey.^2);

display('find coordinates');
[grid] = contour_coordinate_grid( x, y, V, C, u );

display('start plotting');



%--------------------------------------------------------------------------
% Contour Display for electric potential
% fig_id = 3;
% figure(fig_id)
Vmax = max(V(:));
Vmin = min(V(:));
% contour_range_V = Vmin:((Vmax-Vmin)/1000):Vmax;
% contour(x,y,V,contour_range_V,'linewidth',0.5);
% hold on, plot(C(:,1), C(:,2),'k*');
% axis([min(x) max(x) min(y) max(y)]), axis square;
% colorbar('location','eastoutside','fontsize',14);
% xlabel('x-axis in meters','fontsize',14);
% ylabel('y-axis in meters','fontsize',14);
% title('Electric Potential distribution, V(x,y) in volts','fontsize',14);
% h1=gca;
% set(h1,'fontsize',14);
% fh1 = figure(fig_id);
% set(fh1, 'color', 'white')




%--------------------------------------------------------------------------
% % Divergence electric potential
% fig_id = 4;
% figure(fig_id)
% div = divergence(x,y,Ex,Ey);
% surf(x,y,div)
% shading interp
% % colormap winter
% hold on
% density = 10;
% hss = streamslice(x,y,Ex,Ey,density,'cubic');
% set(hss,'color','k')
% length(hss)
% for i=1:length(hss);
%     zi = interp2(div,get(hss(i),'xdata'),get(hss(i),'ydata'));
%     set(hss(i),'zdata',zi);
% end
% view(-360,90); axis tight, axis square
% % plot(C(:,1), C(:,2),'b*');
% title('Electric field Lines, E (x,y) in V/m','fontsize',14);
% % axis([min(x) max(x) min(y) max(y)]);
% colorbar('location','eastoutside','fontsize',14);
% xlabel('x-axis in nb of data points','fontsize',14);
% ylabel('y-axis in nb of data points','fontsize',14);
% h4=gca;
% set(h4,'fontsize',14);
% fh4 = figure(fig_id);
% set(fh4, 'color', 'white')
% 
% % Laplacian electric potential
% fig_id = 5;
% figure(fig_id)
% laplacian = del2(V);
% surf(x,y,laplacian)
% shading interp
% % colormap winter
% view(-360,90); axis tight, axis square
% % plot(C(:,1), C(:,2),'b*');
% title('Laplacian','fontsize',14);
% % axis([min(x) max(x) min(y) max(y)]);
% colorbar('location','eastoutside','fontsize',14);
% xlabel('x-axis in nb of data points','fontsize',14);
% ylabel('y-axis in nb of data points','fontsize',14);
% h4=gca;
% set(h4,'fontsize',14);
% fh4 = figure(fig_id);
% set(fh4, 'color', 'white')




%--------------------------------------------------------------------------
% Contour Display for electric field
% figure(4)
% contour_range_E = 0:0.05:3;
% contour(x,y,E,contour_range_E,'linewidth',0.5);
% axis([min(x) max(x) min(y) max(y)]);
% colorbar('location','eastoutside','fontsize',14);
% xlabel('x-axis in meters','fontsize',14);
% ylabel('y-axis in meters','fontsize',14);
% title('Electric field distribution, E (x,y) in V/m','fontsize',14);
% h2=gca;
% set(h2,'fontsize',14);
% fh2 = figure(4);
% set(fh2, 'color', 'white')

% Quiver Display for electric field Lines
% figure(5)
% contour(x,y,E,'linewidth',0.5);
% hold on, quiver(x,y,Ex,Ey,2)
% title('Electric field Lines, E (x,y) in V/m','fontsize',14);
% axis([min(x) max(x) min(y) max(y)]);
% colorbar('location','eastoutside','fontsize',14);
% xlabel('x-axis in meters','fontsize',14);
% ylabel('y-axis in meters','fontsize',14);
% h3=gca;
% set(h3,'fontsize',14);
% fh3 = figure(5);
% set(fh3, 'color', 'white')




%--------------------------------------------------------------------------
% Electric field Lines
cost_map = false;
if cost_map
    fig_id = 6;
    figure(fig_id)
    surf(V)
    shading interp
    colormap summer
    hold on
    density = 10;
    hss = streamslice(Ex,Ey,density,'cubic');
    set(hss,'color','k')
    length(hss)
    for i=1:length(hss);
        zi = interp2(V,get(hss(i),'xdata'),get(hss(i),'ydata'));
        set(hss(i),'zdata',zi);
    end
    view(-360,90); axis tight, axis square
    % plot(C(:,1), C(:,2),'b*');
    title('Electric field Lines, E (x,y) in V/m','fontsize',14);
    % axis([min(x) max(x) min(y) max(y)]);
    colorbar('location','eastoutside','fontsize',14);
    xlabel('x-axis in nb of data points','fontsize',14);
    ylabel('y-axis in nb of data points','fontsize',14);
    h4=gca;
    set(h4,'fontsize',14);
    fh4 = figure(fig_id);
    set(fh4, 'color', 'white')
end

%--------------------------------------------------------------------------
field_lines = false;
if field_lines
    % Field Lines
    fig_id = 4;
    figure(fig_id)
    % surf(V)
    % shading interp
    % colormap summer
    % hold on
    % view(-360,90); axis tight, axis square
    
    title('Field Lines, E (x,y) in V/m','fontsize',14);
    plot(C(:,1), C(:,2),'k');
    hold on
    contour_range_V = Vmin:((Vmax-Vmin)/10):Vmax;
    contour(x,y,V,contour_range_V,'linewidth',0.5);
    
    k = 300;
    draw_length = xMaxPlot / 10;
    u_draw = linspace(0, 2*pi, 50);
    
    centroid = get_contour_centroid(C);
    
    for i=1:size(u_draw,2)-1,
        
        u_p = u_draw(i);
        [p1, normal1] = get_barycenter_and_normal( u_p+.08, u, C);
        [p2, normal2] = get_barycenter_and_normal( u_p-.08, u, C);
        [p3, normal] = get_barycenter_and_normal( u_p, u, C);
        normal = (normal + normal1 + normal2 ) / 3;
        
        point = p3 + .007*normal;
        
        [line] = follow_field_lines( point, 0.003, k, x, y, V, ... 
            centroid, 0.4, true );
        
        plot( line(:,1), line(:,2), 'k' );
        draw_arrow( [p3(1), p3(1)+draw_length*normal(1)], ...
            [p3(2), p3(2)+draw_length*normal(2)], ...
            {'Color','b','LineWidth', 1});
        plot( point(1), point(2), ...
            'Color', get_color(u_p/(2*pi)), 'Marker','o');
        
        display(['line ' num2str(i)]);
    end
    
    axis([min(x) max(x) min(y) max(y)]);
    axis square
    colorbar('location','eastoutside','fontsize',14);
    xlabel('x-axis in nb of data points','fontsize',14);
    ylabel('y-axis in nb of data points','fontsize',14);
    h5=gca;
    set(h5,'fontsize',14);
    fh5 = figure(fig_id);
    set(fh5, 'color', 'white')
end

%% Get a color green to red
% from a value between 0 and 1
function color = get_color(p)
color = [p 1-p 0];

%% Draw an arrow
function [ h ] = draw_arrow( x, y, props )
h = annotation('arrow');
set(h,'parent', gca, ...
    'position', [ x(1), y(1), x(2)-x(1), y(2)-y(1) ], ...
    'HeadLength', 5, 'HeadWidth', 5, 'HeadStyle', 'cback1', ...
    props{:} );

%% Get the charge at a point induced by a point charge
% p1: is the probe point
% p2: is the inducing point
% q: is the charge
function [potential] = potential_at_point_due_to_element( ...
    p1, p2, charge)
k = 100;
potential = k * charge / ( norm(p1-p2) + 0.01 ); % add 1 cm

%% Get the charge at a point induced by a charged segment
% p: is the probe point
% p1: is the inducing 1st segment point
% p2: is the inducing 2nd segment point
% q: is the charge
function [potential] = potential_at_point_due_to_segment( ...
    p, p1, p2, charge)
k = 1;
[V] = potential_charged_segment_oriented( p1, p2, p );
potential = k * charge * V;

%% Get the potential at a point from point charges
% point: is the probe point
% points: is the inducing points
% charges: of the points
function [potential] = potential_at_point_from_point_charges( ...
    point, points, charges)
potential = 0;
for i=1:size(charges,1),
    potential = potential + potential_at_point_due_to_element( ...
        point, points(i,:), charges(i) );
end

%% Get the potential at a point from segments
% point: is the probe point
% points: is the inducing points
% charges: of the points
function [potential] = potential_at_point_from_segments( ...
    point, segments, charges)
potential = 0;
for i=1:size(charges,1),
    potential = potential + potential_at_point_due_to_segment( ...
        squeeze(point), ... 
        squeeze(segments(i,1,:)), ...
        squeeze(segments(i,2,:)), ...
        charges(i) );
end

%% Descend gradient
function [grid] = contour_coordinate_grid( ...
    x, y, v, ...
    contour, u )

square_size = size(x,2);
arguments = cell( (square_size-1)^2, 1 );

parallel = false;

grid = zeros(size(x,2), size(y,2));

%@ Loop over all grid points
for i=1:(square_size-1) % -1 because of interpolation
    for j=1:(square_size-1) % -1 because of interpolation
        
        % point [x y]
        point = [x(i), y(j)];
       
        
        if parallel,
            
            % functions arguments
            arguments{ (j-1)*(square_size-1) + i } = { point, ...
                0.003, 500, x, y, v, ...
                false,  contour, u };
        else
            
            grid(i,j) = find_coordinates( point, ...
                0.003, 500, x, y, v, ...
                false,  contour, u );
            
            display(['grid point : ' num2str(i) ' ' num2str(j)])
           
        end
    end
end

if parallel
    
    out = exectute_parallel( 22, @find_coordinates, arguments );

    size(out)

    grid = zeros(size(x,2), size(y,2));

    for k=1:size(out)
        i = floor((k-1)/(square_size-1))+1; 
        j = mod(k-1,square_size-1)+1;
        grid(i,j) = out{k};
    end
end

grid( 1:(square_size-1) , 1:(square_size-1) )
save( 'grid.mat', 'grid' );
        

%% Execute parallel function
function [out] = exectute_parallel( nb_jobs, f, arguments )

c = parcluster;
nb_tasks = ceil(size(arguments)/nb_jobs);
k = 1;
jobs = cell(nb_jobs,1);

last_job = 0;

for i=1:nb_jobs
    
    jobs{i} = createJob(c);
    
    for j=1:nb_tasks
        
        disp(['create task ' num2str(k)]) 
        createTask( jobs{i}, f, 1, arguments{k} );
        
        k = k + 1;
        if k > size(arguments,1)
            break
        end
    end
    
    submit(jobs{i})
    display(['submit job : ' num2str(i) ])
    last_job = i;
    
    if k > size(arguments,1)
        break
    end
    
    
end

size(arguments)

out = cell(size(arguments),1);
k = 1;

size(jobs)

for i=1:last_job
    wait(jobs{i});
    output = fetchOutputs(jobs{i});
    disp(output);
    delete(jobs{i});
    
    % get the output for each task
    for j=1:size(output,1),    
        out{ (i-1)*size(output,1) + j } = output{j};
    end
end

disp('parallel execution done')
        
    
%% Loss function
function [A,probes] = get_charge_matrix( ... 
    u, contour, nb_charges, use_point_charge )

probes = zeros(nb_charges,2);

u_t = linspace(0, 2*pi, nb_charges+1);

if use_point_charge,
    
    for i=1:nb_charges,
        probes(i,:) = get_point_on_contour( u_t(i), u, contour );
    end
    A = zeros(nb_charges, nb_charges);
    for i=1:nb_charges,
        for j=1:nb_charges,
            if i ~= j,
                A(i,j) = potential_at_point_due_to_element( ...
                    probes(i,:), probes(j,:), 1 );
            else
                A(i,j) = 10000;
            end
        end
    end
    
else % use segment
    
    segments = get_segments( u, contour, u_t );
    
    for i=1:nb_charges,
        % barycenters
        probes(i,:) = ( segments(i,1,:) + segments(i,2,:) ) / 2;
    end
    
    A = zeros(nb_charges, nb_charges);
    for i=1:nb_charges,
        for j=1:nb_charges,
            
            if i ~= j,
                A(i,j) = potential_at_point_due_to_segment( ...
                    squeeze(probes(i,:)) , ...
                    squeeze(segments(j,1,:)), ...
                    squeeze(segments(j,2,:)), ...
                    1 );
            else
                A(i,j) = 100000;
            end
        end
    end
end

%% Loss function
function [q, points] = simulate_charge( ... 
    u, contour, nb_charges, use_point_charge )

[A, points] = get_charge_matrix( ...
    u, contour, nb_charges, use_point_charge );

B = ones(size(A,1),1);
q = linsolve(A,B);
% q
