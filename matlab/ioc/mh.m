% function mh(iters, burnin, psig, pausevery)
%
% Metropolis-Hastings sampler demonstration
%
% iters: how many iterations total
% burnin: how many iterations for burnin
% psig: std dev of proposal step (e.g. .1, .25)
% pausevery: stop and display progress this often (0 for never)
%
% For example,
%   mh(5000, 1000, .25, 0)
%   mh(1000, 300, .1, 20)

function mh(iters, burnin, psig, pausevery)

parallel = 1;				% number of parallel
                                        % trajectories to display
                                        % at once

[xs, ys] = meshgrid(-1:.05:1);

% plot function to integrate
figure(1);
zs = foo(xs,ys);
surfl(xs,ys,zs);
shading interp;
xlabel X
ylabel Y
zlabel f(X,Y)
set(gca,'CameraPosition', [13.017 -4.10426 29.1589])
% print -depsc foo.eps

% get true integral x^2*foo(x,y) by fine discretization
zs = zs./sum(zs(:));
fprintf('True E(x^2) %f\n', sum(sum(zs.*xs.*xs)));

% contour plot of function to integrate, on top of which we will
% plot progress of MH
figure(2);
contourf(xs,ys,foo(xs,ys));

% initial point for MH
x = zeros(parallel,1);
y = x;
v = foo(x,y);

% record the samples and acceptance decisions
samples = zeros(parallel, iters);
accept = zeros(parallel, iters);

% the MH sampler
for i = 1:iters

  % sample from proposal distribution (and possibly plot)
  nx = x + randn(size(x))*psig;
  ny = y + randn(size(y))*psig;
  nv = foo(nx, ny);
  if (pausevery > 0 && mod(i, pausevery)==0)
    h = line(nx, ny, 'Marker', 'o', 'MarkerSize', 15, 'LineWidth', 2, ...
	     'Color', [1 .5 .5], 'LineStyle', 'none');
  end

  % compute acceptance probability and decide which proposals to
  % accept; note Q is symmetric, so we don't need its ratio
  accprob = nv ./ v;
  mask = rand(size(x))>accprob;
  nx(mask) = x(mask);
  ny(mask) = y(mask);

  % add this step to the plot
  if (pausevery > 0)
    line([x nx]', [y ny]');
  else
    line(nx, ny, 'Marker', '.');
  end
  
  % do the update and remember the sample
  x = nx;
  y = ny;
  samples(:,i) = x.^2;
  accept(:,i) = ~mask;

  % pause for a plot if desired
  if (pausevery > 0 && mod(i, pausevery)==0)
    fprintf('acceptance rate %f\n', mean(mean(accept(:,1:i))));
    if (i > burnin)
      fprintf('current estimate %f\n', mean(mean(samples(:,burnin:i))));
    end
    pause
    delete(h)
  end
end

fprintf('final acceptance rate %f\n', mean(mean(accept)));
fprintf('final estimate %f\n', mean(mean(samples)));

% print -depsc mh-path.eps

return;


function zs = foo(xs, ys)

zs = exp(sin(2*pi*(xs+ys))-xs-2*(xs-.3).^2-2*ys.^2)+2*exp(-(xs-ys).^2);
zs(xs<-1) = 0;
zs(xs>1) = 0;
zs(ys<-1) = 0;
zs(ys>1) = 0;

return;
