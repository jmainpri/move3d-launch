close all
z = peaks;
surf(z)
shading interp
hold on
[c ch] = contour3(z,20); set(ch,'edgecolor','b')
[u v] = gradient(z); 
h = streamslice(-u,-v); 
set(h,'color','k')
z
for i=1:length(h); 
    zi = interp2(z,get(h(i),'xdata'),get(h(i),'ydata'));
    zi
    set(h(i),'zdata',zi);
end
view(30,50); axis tight