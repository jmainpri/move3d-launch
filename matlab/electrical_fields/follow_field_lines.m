%% descend the field line of F
% X are the discretized x data points
% Y are the discretized y data points
% F is the discretized potential field
% k is the number of steps
% t is the time to descend
% neta is the scaling
% point is the start of the descent
function [line] = follow_field_lines( ... 
    point, neta, iteration_limit, X, Y, F, ... 
    center, max_distance, ...
    descent )

dt = 1e-6;
x = point(1);
y = point(2);
line = zeros(iteration_limit,2);
last_iteration = 1;

for i = 1:iteration_limit,
    
    if ( x > max(X) ) || ( y > max(Y) )
        break
    end
    if ( x < min(X) ) || ( y < min(Y) )
        break
    end
    
    line(i,:) = [x y];
    
    if norm([x y] - center) > max_distance
        break
    end
    
    f0 = interp2( X, Y, F, x, y, 'cubic' );
    dx = ( interp2( X, Y, F, x+dt, y, 'cubic' ) - f0 ) / dt;
    dy = ( interp2( X, Y, F, x, y+dt, 'cubic' ) - f0 ) / dt;
    
    norm_gradient = norm([dx dy]);
    
    if descent
        x = x - neta*( dx / norm_gradient );
        y = y - neta*( dy / norm_gradient );
    else
        x = x + neta*( dx / norm_gradient );
        y = y + neta*( dy / norm_gradient );
    end
    
    if isnan(f0) ,
        error('is nan');
    end
    
    last_iteration = i;
end

if last_iteration < iteration_limit,
    % The line is stored with a (x,y) point per row
    % next erase the last rows of the matrix
    line(last_iteration+1:end,:) = [];
    display(['stopped at iteration ' num2str(last_iteration)]);
end




