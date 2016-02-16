function C = costmap( centers, xMax, xMin )

n_points = 100;
X = linspace(xMin,xMax,n_points);
Y = X;
points = zeros(n_points, n_points, 2);
costs = zeros(n_points, n_points);

i = 0; j = 0;
for x = X ,
    i = i + 1;
    j = 0;
    for y = Y,
        j = j + 1;
        points(i, j, :) = [x,y];
        costs(i, j) = distance_min( [x,y], centers );
    end
end

% figure
% imagesc( costs, [0, 15]);
% surf(X,Y,costs);
threshold = .06;
[C] = contourc( X, Y, costs, [threshold threshold]);

% Flip the contour if nessary
% to guet proper normal computations
if is_clock_wise(C) == 1,
    disp(['reverse contour order']);
    C(1,2:end) = fliplr(C(1,2:end));
    C(2,2:end) = fliplr(C(2,2:end));
end

%plot(C(1,2:end), C(2,2:end));
%axis([xMin xMax xMin xMax]);

% pause;
% figure
% quiver( X, Y, costs, gradient(costs))

%  title(['Number : ' num2str(run,formatSpec)]);
%  colorbar

% point is the querry point
% centers are the points where to compute the distance from
C = C(:,2:end)';

% Remove potential looping of the contour
while C(1,:) == C(end,:),
    C = C(2:end,:);
    display('remove same init and end');
end

%% Minimal distance
function e = distance_min( point, centers )
p = repmat(point, size(centers,1), 1);
dist = sqrt(sum((p - centers)' .^ 2))';
e = min( dist );

%% Is the polygone clock wise
% returns one if the polygone
% is degined clockwise
function Ccw = is_clock_wise(C)
if (size(C) < 3),
    Ccw = -1;
    return
end
count = 0;
n = size(C,2);
for i=2:(n),
    j = mod( (i + 1), n)+1;
    k = mod( (i + 2), n)+1;
    z = (C(1,j) - C(1,i)) * (C(2,k) - C(2,j));
    b = (C(2,j) - C(2,i)) * (C(1,k) - C(1,j));
    z = z - b;
    if (z < 0),
        count = count - 1;
    else
        if (z > 0),
            count = count + 1;
        end
    end
end
if (count > 0),
    Ccw = 0;
else
    if (count < 0),
        Ccw = 1;
    else
        Ccw = -1;
    end
end
