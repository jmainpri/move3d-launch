function plot_ioc_results_function( samples, results )

figure

if size(results,1) > 1,
    
    plot(samples,mean(results(:,:,3)))
    hold on
    % errorbar(1:nb_tests,mean(results(:,:,3)),min(results(:,:,3)),max(results(:,:,3)))
    errorbar(samples,mean(results(:,:,3)),std(results(:,:,3)))
    title('Cost difference');
    
    figure
    plot(samples,mean(results(:,:,4)))
    hold on
    errorbar(samples,mean(results(:,:,4)),std(results(:,:,4)))
    title('Weight euqulidean distance');
    
else
    plot(samples,results(:,:,3))
%     hold on
%     plot(samples,results(:,:,4),'r')
end