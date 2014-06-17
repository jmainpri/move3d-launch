function plot_weights( samples, w )

w_o = [ 1.0, 1.0, 1.0, 1.0, ...
        1.0, 0.5, 0.08, 1.0, ...
        1.0, 0.3, 0.5, 1.0, ...
        1.0, 1.0, 1.0, 1.0, ...
        ];
    
    w_mean = zeros(size(w,2),size(w,3));
    w_std = zeros(size(w,2),size(w,3));
    
    for r=1:size(w,2), % nb of sample sequences
        w_mean(r,:) = mean( squeeze(w(:,r,:)) );
    end
    
    for r=1:size(w,2), % nb of sample sequences
        w_std(r,:) = std( w(:,r,:) );
    end
    
    figure
    for r=1:size(w,2), % nb of sample sequences
        subplot(2,5,r);
        plot_one_weight(w_mean(r,:),'b')
        title(['Sample : ' num2str(samples(r))])
        % plot_one_weight(w_std(r,:),'r')
        plot_one_weight(w_o,'k')
    end
end

function plot_one_weight(w,c)

    w = 0.30*w;
    circle(-1.5,1.5,w(1),c);  circle(-0.5,1.5,w(2),c);  circle(0.5,1.5,w(3),c);  circle(1.5,1.5,w(4),c);
    circle(-1.5,0.5,w(5),c);  circle(-0.5,0.5,w(6),c);  circle(0.5,0.5,w(7),c);  circle(1.5,0.5,w(8),c);
    circle(-1.5,-0.5,w(9),c); circle(-0.5,-0.5,w(10),c); circle(0.5,-0.5,w(11),c); circle(1.5,-0.5,w(12),c);
    circle(-1.5,-1.5,w(13),c); circle(-0.5,-1.5,w(14),c); circle(0.5,-1.5,w(15),c); circle(1.5,-1.5,w(16),c);
    axis square
end

function circle(x,y,r,c)
%x and y are the coordinates of the center of the circle
%r is the radius of the circle
%0.01 is the angle step, bigger values will draw the circle faster but
%you might notice imperfections (not very smooth)
ang=0:0.01:2*pi; 
xp=r*cos(ang);
yp=r*sin(ang);
plot(x+xp,y+yp,c);
hold on
end