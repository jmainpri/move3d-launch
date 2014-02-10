% result = load('data/result.txt');
% plot(result(:,3))
% axis([2 30 0 10])

figure 

% samples = 1:nb_sampling_phase;
% for i=0:nb_sampling_phase-1, 
%     samples(i+1) = floor( min_samples + i*(max_samples-min_samples)/(nb_sampling_phase-1) );
% end

samples = 16*[1:10];

A = load('results_random_4.mat');
results1 = A.results;

A = load('results_per_feature_4.mat')
results2 = A.results;

plot( samples, mean(results(:,:,3)))
hold on
errorbar( samples, mean(results1(:,:,3)),std(results1(:,:,3)))

plot( samples, mean(results(:,:,3)))
hold on
errorbar(samples, mean(results2(:,:,3)),std(results2(:,:,3)),'r')

figure
plot(samples,mean(results1(:,:,4)))
hold on
errorbar(samples,mean(results1(:,:,4)),std(results1(:,:,4)))

plot(samples,mean(results2(:,:,4)))
hold on
errorbar(samples,mean(results2(:,:,4)),std(results2(:,:,4)),'r')

% A = load('results_stomp_2.mat')
% results = A.results
% plot( samples, mean(results(:,:,3)))
% hold on
% errorbar(samples, mean(results(:,:,3)),std(results(:,:,3)),'g')

% V = axis
% axis([samples(1) samples(end) V(3) V(4)])