nb_sampling_phase = 20

A = load('results_stomp.mat');
result1 = A.results;

plot(mean(result1(:,:,3)))
hold on
errorbar(1:nb_sampling_phase,mean(result1(:,:,3)),std(result1(:,:,3)))

A = load('results_random.mat');
result2 = A.results;

hold on
plot(mean(result2(:,:,3)),'r')
errorbar(1:nb_sampling_phase,mean(result2(:,:,3)),std(result2(:,:,3)),'r')

