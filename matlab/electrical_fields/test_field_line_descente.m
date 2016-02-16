function test_field_line_descente()

min_value = -2;
max_value = 2;

v = min_value:0.1:max_value;
[x,y] = meshgrid(v);
z = x .* exp(-x.^2 - y.^2);

contour(v,v,z)
hold on
[px,py] = gradient(z,.2,.2);
quiver(v,v,-px,-py)
axis square

x0 = (max_value-min_value) * rand() + min_value;
y0 = (max_value-min_value) * rand() + min_value;


max_iterations = 100;
neta = .02;
descent = false;

[line] = follow_field_lines( [x0 y0], neta, max_iterations, v, v, z, ... 
    [0 0], 20, descent );

for i=1:size(line,1)
    
    s = i / size(line,1); % color selection between 0 and 1
    
    plot( line(i,1), line(i,2), ...
        'Color', [s 1-s 0], ...
        'Marker','*' )
end

hold off