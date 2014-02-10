% result = load('data/result.txt');
% plot(result(:,3))
% axis([2 30 0 10])

figure 

samples = 1:nb_sampling_phase;
for i=0:nb_sampling_phase-1, 
    samples(i+1) = floor( min_samples + i*(max_samples-min_samples)/(nb_sampling_phase-1) );
end

A = load('results_random_2.mat')
results = A.results
plot( samples, mean(results(:,:,3)))
hold on
errorbar( samples, mean(results(:,:,3)),std(results(:,:,3)))

A = load('results_per_feature_3.mat')
results = A.results
plot( samples, mean(results(:,:,3)))
hold on
errorbar(samples, mean(results(:,:,3)),std(results(:,:,3)),'r')

% A = load('results_stomp_2.mat')
% results = A.results
% plot( samples, mean(results(:,:,3)))
% hold on
% errorbar(samples, mean(results(:,:,3)),std(results(:,:,3)),'g')

% V = axis
% axis([samples(1) samples(end) V(3) V(4)])