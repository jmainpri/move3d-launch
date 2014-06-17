function plot_feature_gradient_sum(samples,jacob_feat)

figure

% formatSpec = '%02d';

subplot(5,2,1);
bar( jacob_feat{1}(1,:) )
% V = axis;
% axis([V(1) V(2) 0 4])
title(['Demonstration']);

for i=1:( size(samples,2)-1 ),
    subplot(5,2,i+1);
    bar( mean(jacob_feat{i}(2:end,:)) )
%     V = axis;
%     axis([V(1) V(2) 0 4])
    title(['Samples : ' num2str( samples(i) ) ] );
end