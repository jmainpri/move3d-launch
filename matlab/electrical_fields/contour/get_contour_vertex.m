%% Get point on contour
function point = get_contour_vertex( id, contour )
point = [contour(id,1) contour(id,2)];