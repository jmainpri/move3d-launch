%% Get the barycenter and the normal
% given the id of a vertex and the contour
function [barycenter, normal] = get_barycenter_and_normal( ...
    u_point, u, contour )
p1 = get_point_on_contour( u_point-1e-3, u, contour );
p2 = get_point_on_contour( u_point+1e-3, u, contour );
barycenter = (p1 + p2) / 2;
normal = zeros(1,2);
dx = p2(1) - p1(1);
dy = p2(2) - p1(2);
normal(1) = dy;
normal(2) = -dx;
normal = normal / norm(normal);