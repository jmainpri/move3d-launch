%% Get the barycenter of the contour
function [centroid] = get_contour_centroid(contour)
centroid = zeros(1,2);
for i=1:size(contour,1)
    centroid = centroid + get_contour_vertex(i,contour);
end
centroid = centroid / size(contour,1);