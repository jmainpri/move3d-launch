%% Get segments of contour (contour)
function segments = get_segments( u, contour, u_t )
nb_segments = size(u_t,2)-1;
segments = zeros(nb_segments,2,2);
for i=1:nb_segments,
    segments(i,1,:) = get_point_on_contour( u_t(i), u, contour );
    segments(i,2,:) = get_point_on_contour( u_t(i+1), u, contour );
    if segments(i,1,:) == segments(i,2,:),
        segments(i,1,:)
        segments(i,2,:)
        u_t(i)
        u_t(i+1)
        error('error segments end are equal')
    end
end