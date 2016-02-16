%% Finds the coordinates by performing gradient ascent
function [u_point,line] = find_coordinates( point, neta, ... 
    iteration_limit, X, Y, F, ... 
    descent, ...
    contour, u )

dt = 1e-6;
x = point(1);
y = point(2);
line = zeros(iteration_limit,2);
last_iteration = 1;
min_distance = .01;
u_point = 0;
distance = 0;

addpath('contour/');

for i = 1:iteration_limit,
    
    if ( x > max(X) ) || ( y > max(Y) )
        break
    end
    if ( x < min(X) ) || ( y < min(Y) )
        break
    end
    
    line(i,:) = [x y];
    
    % Get distance to contour
    [distance, u_c] = distance_to_contour( [x y], u, contour );
    
    if distance < min_distance
        display('hit border')
        u_point = u_c;
        break
    end
    
    f0 = interp2( X, Y, F, x, y, 'cubic' );
    if isnan(f0) ,
        error('is nan');
    end
    
    dx = ( interp2( X, Y, F, x+dt, y, 'cubic' ) - f0 ) / dt;
    dy = ( interp2( X, Y, F, x, y+dt, 'cubic' ) - f0 ) / dt;
    
    if isnan(dx) || isnan(dy)
        error('is nan');
    end
    
    norm_gradient = norm([dx dy]);
    
    if descent
        x = x - neta*( dx / norm_gradient );
        y = y - neta*( dy / norm_gradient );
    else
        x = x + neta*( dx / norm_gradient );
        y = y + neta*( dy / norm_gradient );
    end
    
    last_iteration = i;
end

distance
last_iteration

if last_iteration < iteration_limit,
    % The line is stored with a (x,y) point per row
    % next erase the last rows of the matrix
    line(last_iteration+1:end,:) = [];
    display(['stopped at iteration ' num2str(last_iteration)]);
end

%% Gets the distance to the contour
function [distance, u_point] = distance_to_contour( point, u, contour )

distance = 100000;
u_p = linspace(0, 2*pi, 100);
for i=1:size(u_p,2)-1,
    p = get_point_on_contour( u_p(i), u, contour);
    dist = norm( p - point );
    if dist < distance,
        distance = dist;
        u_point =  u_p(i);
    end
end



