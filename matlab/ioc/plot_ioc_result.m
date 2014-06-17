% result = load('data/result.txt');
% plot(result(:,3))
% axis([2 30 0 10])

figure 

% samples = 1:nb_sampling_phase;
% for i=0:nb_sampling_phase-1, 
%     samples(i+1) = floor( min_samples + i*(max_samples-min_samples)/(nb_sampling_phase-1) );
% end

matlab_dir = '/home/jmainpri/Dropbox/move3d/move3d-launch/matlab/';

cd( matlab_dir );

samples = 16*[1:10];

% A = load('results_current/test_1_00_around_demo.mat'); % blue % 1.0
A = load('results_square_random_1_0.mat');
r0 = A.results;

% A = load('results_current/test_0_05_around_demo.mat'); % green % 0.05
%A = load('results_square_random_0_05.mat');
% r1 = A.results;

% A = load('results_current/test_0_03_around_demo.mat'); % black
% A = load('results_current/test3.mat'); % 0.03
%A = load('results_square_random_0_03.mat');
% r2 = A.results;

% A = load('results_current/test_0_01_around_demo.mat'); % red
% A = load('results_current/test3.mat'); % 0.03
%A = load('results_square_random_0_03.mat');
% r3 = A.results;

% -------------------------------------------------------

% A = load('results_current/weights_1_00_around_demo.mat'); % 1.0
% w0 = A.recovered_weights;
% % plot_weights( samples, A.recovered_weights )
%  
% A = load('results_current/weights_0_05_around_demo.mat'); % 0.05
% w1 = A.recovered_weights;
% % plot_weights( samples, A.recovered_weights )
% 
% A = load('results_current/weights_0_03_around_demo.mat');
% w2 = A.recovered_weights;
% % plot_weights( samples, A.recovered_weights )
% % figure
% A = load('results_current/weights_0_01_around_demo.mat');
% w3 = A.recovered_weights;

% -------------------------------------------------------
use_subplot = false;
plot_cost_comparison = true;
if( plot_cost_comparison ),

    max_y = 20;

    if use_subplot,
        subplot(2,2,1);
    end
    r = r0;
    plot( samples, mean(r(:,:,3)))
    hold on
    errorbar( samples, mean(r(:,:,3)),std(r(:,:,3)),'b')
    xlabel('nb of samples');
    ylabel('Cost Difference');
    if use_subplot,
        title('Random sigma = 1.00')
        % V = axis;
        axis([0 180 -5 max_y]);
    end

    if use_subplot,
        subplot(2,2,2);
    end
    r = r1;
    plot( samples, mean(r(:,:,3)))
    hold on
    errorbar( samples, mean(r(:,:,3)),std(r(:,:,3)),'g')
    xlabel('nb of samples');
    ylabel('Cost Difference');
    if use_subplot,
        title('Random sigma = 0.05')
        axis([0 180 -5 max_y]);
    end

    if use_subplot,
        subplot(2,2,3);
    end
    r = r2;
    plot( samples, mean(r(:,:,3)),'k')
    hold on
    errorbar(samples, mean(r(:,:,3)),std(r(:,:,3)),'k')
    xlabel('nb of samples');
    ylabel('Cost Difference');
    if use_subplot,
        title('Random sigma = 0.01')
        axis([0 180 -5 max_y]);
    end

    if use_subplot,
        subplot(2,2,4);
    end
    r = r3;

    if( size( r(:,:,3) ) ~= 1 )
        plot( samples, mean(r(:,:,3)),'r')
        hold on
        errorbar(samples, mean(r(:,:,3)),std(r(:,:,3)),'r')
    end
    xlabel('nb of samples');
    ylabel('Cost Difference');
    if use_subplot,
        title('Per feature')
        axis([0 180 -5 max_y]);
    end

    if ~use_subplot,
        title('Cost Difference Of Optimal Path to Demonstration')
    end
end

% -------------------------------------------------------

% plot_weights( samples, w0 )
% plot_weights( samples, w1 )
% plot_weights( samples, w2 )
% plot_weights( samples, w3 )

figure

max_y = 3;

if use_subplot,
    subplot(2,2,1);
end
w = r0(:,:,4);
plot( samples, mean(w) )
hold on
errorbar( samples, mean(w),std(w))
xlabel('nb of samples');
ylabel('Weight Distance');
if use_subplot,
    title('Random sigma = 1.00')
    % V = axis;
    axis([0 180 0 max_y]);
end

if use_subplot,
    subplot(2,2,2);
end
w = r1(:,:,4);
plot( samples, mean(w) )
hold on
errorbar( samples, mean(w),std(w),'g')
xlabel('nb of samples');
ylabel('Weight Distance');
if use_subplot,
    title('Random sigma = 0.05')
    axis([0 180 0 max_y]);
end

if use_subplot,
    subplot(2,2,3);
end
w = r2(:,:,4);
plot( samples, mean(w),'k')
hold on
errorbar(samples, mean(w),std(w),'k')
xlabel('nb of samples');
ylabel('Weight Distance');
if use_subplot,
    title('Random sigma = 0.03')
    axis([0 180 0 max_y]);
end
    
if use_subplot,
    subplot(2,2,4);
end
w = r3(:,:,4);
plot( samples, mean(w),'r')
hold on
% if( size( r(:,:,4) ) ~= 1 )
    errorbar(samples, mean(w),std(w),'r')
% end
xlabel('nb of samples');
ylabel('Weight Distance');
if use_subplot,
    title('Per feature')
    axis([0 180 0 max_y]);
end

if ~use_subplot,
    title('Recovered Weights Difference To True Weights')
end

% TEST RECOVERED WEIGHTS
% w_o = [ 1.0, 1.0, 1.0, 1.0, ...
%         1.0, 0.5, 0.08, 1.0, ...
%         1.0, 0.3, 0.5, 1.0, ...
%         1.0, 1.0, 1.0, 1.0, ...
%         ];
%     
% % mean( r0(:,:,4) )
% 
% 
% w_tmp = zeros( size(r3(:,:,4)) );
% 
% for i=1:size(w_tmp,1),
%     for j=1:size(w_tmp,2),
%         w_tmp(i,j) = norm( squeeze(w3(i,j,:)) - w_o' );
%     end
% end
% 
% r3(:,:,4) - w_tmp


% -------------------------------------------------------
% figure
% plot(samples,mean(results1(:,:,4)))
% hold on
% errorbar(samples,mean(results1(:,:,4)),std(results1(:,:,4)))
% 
% plot(samples,mean(results2(:,:,4)))
% hold on
% errorbar(samples,mean(results2(:,:,4)),std(results2(:,:,4)),'r')

% A = load('results_stomp_2.mat')
% results = A.results
% plot( samples, mean(results(:,:,3)))
% hold on
% errorbar(samples, mean(results(:,:,3)),std(results(:,:,3)),'g')

% V = axis
% axis([samples(1) samples(end) V(3) V(4)])