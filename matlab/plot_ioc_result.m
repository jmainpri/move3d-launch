% result = load('data/result.txt');
% plot(result(:,3))
% axis([2 30 0 10])

figure 

% samples = 1:nb_sampling_phase;
% for i=0:nb_sampling_phase-1, 
%     samples(i+1) = floor( min_samples + i*(max_samples-min_samples)/(nb_sampling_phase-1) );
% end

cd( matlab_dir );

samples = 16*[1:10];

A = load('results_current/test1.mat'); % 1.0
%A = load('results_square_random_1_0.mat');
r0 = A.results;

A = load('results_current/test2.mat'); % 0.05
%A = load('results_square_random_0_05.mat');
r1 = A.results;

A = load('results_current/test3.mat'); % 0.03
%A = load('results_square_random_0_03.mat');
r2 = A.results;

A = load('results_current/results_per_feature.mat');
r3 = A.results;

% -------------------------------------------------------

use_subplot = true;

if use_subplot,
    subplot(2,2,1);
end
r = r0;
plot( samples, mean(r(:,:,3)))
hold on
errorbar( samples, mean(r(:,:,3)),std(r(:,:,3)))
xlabel('nb of samples');
ylabel('Cost Difference');
if use_subplot,
    title('Random sigma = 1.00')
    % V = axis;
    axis([0 180 -5 50]);
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
    axis([0 180 -5 50]);
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
    title('Random sigma = 0.03')
    axis([0 180 -5 50]);
end
    
if use_subplot,
    subplot(2,2,4);
end
r = r3;
plot( samples, mean(r(:,:,3)),'r')
hold on
errorbar(samples, mean(r(:,:,3)),std(r(:,:,3)),'r')
xlabel('nb of samples');
ylabel('Cost Difference');
if use_subplot,
    title('Per feature')
    axis([0 180 -5 50]);
end

if ~use_subplot,
    title('Cost Difference Of Optimal Path to Demonstration')
end

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