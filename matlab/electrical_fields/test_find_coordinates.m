function test_find_coordinates()

data = load('V.mat');
v = data.V';
x = data.x;
y = data.y;
C = data.C;
u = data.u;

% performs gradient ascent
[u_p,line] = find_coordinates( [x(1) y(1)], 0.003, ...
    500, x, y, v, ...
    false, ...
    C, u );

u_p

fig_id = 1;
figure(fig_id)

plot( C(:,1), C(:,2),'k');
hold on
contour_range_v = min(v(:)):((max(v(:))-min(v(:)))/10):max(v(:));
contour(x,y,v,contour_range_v,'linewidth',0.5);

for i=1:size(line,1)
    
    s = i / size(line,1); % color selection between 0 and 1
    
    plot( line(i,1), line(i,2), ...
        'Color', [s 1-s 0], ...
        'Marker','*' )
end

axis square
colorbar('location','eastoutside','fontsize',14);
xlabel('x-axis in nb of data points','fontsize',14);
ylabel('y-axis in nb of data points','fontsize',14);
h5=gca;
set(h5,'fontsize',14);
fh5 = figure(fig_id);
set(fh5, 'color', 'white')