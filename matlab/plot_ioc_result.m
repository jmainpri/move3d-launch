% result = load('data/result.txt');
% plot(result(:,3))
% axis([2 30 0 10])

%close
plot(mean(results(:,:,3)))
hold on
% errorbar(1:nb_tests,mean(results(:,:,3)),min(results(:,:,3)),max(results(:,:,3)))
errorbar(1:nb_sampling_phase,mean(results(:,:,3)),std(results(:,:,3)))