%% Get potential for segment
% p0 :  first extremity of segment
% p1 : second extremity of segment
% point for which to assess potential
function [V] = potential_charged_segment_oriented(p0,p1,p)
x0_segment = 0;
k = 1;
Q = 1;
x_axis = p1-p0; % Get x_axis direction (perpendicular to normal)
L = norm(x_axis); % Length of segment
x_axis = x_axis / L; % normalize x_axis
[x,y] = transform_point(p,p0,x_axis);
if y == 0,
    y = y + 10e-6; % Trick for integration ... TODO change that
end
V = potential_charged_axis_aligned_segment(y,-x,x0_segment,L,k,Q);

%% Get potential for linear charge
% d : distance to origin
% x0 : x in origin coordinates
% x0_segment : where the segment start along x axis
% L : length of segment
function [V] = potential_charged_axis_aligned_segment(d,x0,x0_segment,L,k,Q)
l = x0 + x0_segment;
a = (L+l) + sqrt( (L+l)^2 + d^2 );
b = (l)   + sqrt( (l)^2 + d^2 );
V = (k*Q/L)*log( a / b );

%% Get point in segment coordinates
% p1 : point to transform
% p0 : origin of the frame
% x axis : perpendicular to the normal, x axis of the frame
function [x,y] = transform_point( p, p0, x_axis )
R = [[x_axis(1), -x_axis(2), p0(1)]
    [ x_axis(2),  x_axis(1), p0(2)]
    [0 0 1]];
pt = R \ [p 1]'; % = inv(R) * p
x = pt(1);
y = pt(2);

