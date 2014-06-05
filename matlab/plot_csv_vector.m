clear; clc;

write_test_data = false;

if write_test_data,
    
    steps = 100;

    t = linspace(0,3,steps); % 3 seconds
    x = sin(t);
    y = cos(t);
    z = sin(t) - cos(t);

    M = zeros(4,steps);
    
    M(1,:) = t;
    M(2,:) = x;
    M(3,:) = y;
    M(4,:) = z;

    csvwrite('tmp_signal.csv',M)
else
    
    M = csvread('tmp_signal.csv');
    
    t = M(1,:);
    x = M(2,:);
    y = M(3,:);
    z = M(4,:);
end

subplot(3,1,1)
plot( t, x );
title('Distance 1')
subplot(3,1,2)
plot( t, y );
title('Distance 2')
subplot(3,1,3)
plot( t, z );
title('Veclocity Norm')