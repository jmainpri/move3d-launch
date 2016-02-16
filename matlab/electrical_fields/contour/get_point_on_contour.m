%% Get point on the surface (contour)
% in 2D only use the u input
function point = get_point_on_contour( u_point, u, contour )
id0 = size(u,2);
id1 = 1;
u_tmp = wrapTo2Pi( u_point );
for i=1:size(u,2),
    if u_tmp < u(i),
        id1 = i;
        id0 = id1 - 1;
        break
    end
end
start_id = 1;
if id1 > size(u,2),
    id1 = start_id;
    disp('wrapping');
end
if id0 < start_id,
    id0 = size(u,2);
    disp('smaller than start');
end
p0 = get_contour_vertex(id0, contour);
p1 = get_contour_vertex(id1, contour);
t = angdiff( u_point , u(id0) ) / angdiff( u(id1) , u(id0) );
point = (1-t)*p0 + t*p1;
