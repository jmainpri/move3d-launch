function print_stats( demo_id, phi_demo, phi_samples, w_o, w_1, plot_markers )

phi_mean = mean(phi_samples);
phi_variance = var(phi_samples);

% disp('---------------------------------------------')
% disp(['phi mean : ' num2str(phi_mean)])
% disp('---------------------------------------------')
% disp(['phi variance : ' num2str(phi_variance)])

% detlas are difference to the demonstration
deltas = zeros( size( phi_samples, 1 ), size( phi_samples, 2 ) );

% sumss are the sum of each feature delta vector
sumss = zeros( 1, size( phi_samples , 1 ) );

% max features
maximums = zeros( 1, size( phi_samples , 1 ) );

% min features
minimus = zeros( 1, size( phi_samples , 1 ) );

% costs of samples
costs = zeros( 1, size( phi_samples , 1 ) );

for i=1:size( phi_samples ),
    deltas(i,:) = ( phi_samples(i,:) - phi_demo );
    sumss(i) = sum( deltas(i,:) );
    maximums(i) = max( deltas(i,:) );
    minimus(i) = min( deltas(i,:) );
end

% disp('---------------------------------------------')
% disp(['deltas : ' num2str(mean( deltas )) ] )
% disp('---------------------------------------------')
% disp(['mean deltas sum : ' num2str(mean( sumss )) ] )

disp('*********************************************')
disp(['NB SAMPLES : ' num2str( size( phi_samples, 1 ) ) ' NB FEATURES : ' num2str( size( phi_samples, 2 ) )] )
disp('---------------------------------------------')
disp('DELTAS STATISTICS:')
disp(['MEAN : ' num2str( norm( phi_mean ) ) ] )
disp(['VARIANCE : ' num2str( norm( phi_variance ) ) ] )
disp(['MAX MEAN : ' num2str( mean( maximums ) ) ] )
disp(['MAX MAX : ' num2str( max( maximums ) ) ] )
disp(['MIN MEAN : ' num2str( mean( minimus ) ) ] )
disp(['MIN MIN : ' num2str( min( minimus ) ) ] )
disp('---------------------------------------------')
    
% costs = delta_exponential_cost( w_o, deltas );
costs = delta_exponential_cost( w_o, phi_samples );
demo_cost = delta_exponential_cost( w_o, phi_demo );

disp(['DEMO  COST : ' num2str( demo_cost ) ] )
disp('---------------------------------------------')
disp(['SUM  COST : ' num2str( sum(costs) ) ] )
disp(['MEAN  COST : ' num2str( mean(costs) ) ] )
disp(['MAX  COST : ' num2str( max(costs) ) ] )
disp(['MIN  COST : ' num2str( min(costs) ) ] )
disp(['VAR  COST : ' num2str( var(costs) ) ] )
disp('---------------------------------------------')

if demo_cost < min(costs),
    disp('ACCEPTABLE WEIGHT (demo_cost < min of sample costs)')
else
    disp('NOT ACCEPTABLE WEIGHT (demo_cost > min of sample costs)')
end

index = find(costs < demo_cost);
number_of_degeneration = length(index);
disp(['number of degenration : ' num2str(number_of_degeneration)])


% plot the cost of sampled trajectories compared to the demonstration
% nb_label = 29
nb_label = 24;

% Labels = {'Length', ...                 % 01
%     'Smoothness', ...                   % 02
%     'Collision', ...                    % 03
%     'd(Pelvis, Pelvis)', ...            % 04    00
%     'd(Pelvis , rWristX)', ...          % 05    01
%     'd(Pelvis , rElbowZ)', ...          % 06    02
%     'd(Pelvis , rShoulderX)', ...       % 07    03
%     'd(rWristX , Pelvis)', ...          % 08    04
%     'd(rWristX , rWristX)', ...         % 08    05
%     'd(rWristX , rElbowZ)', ...         % 08    06
%     'd(rWristX , rShoulderX)', ...      % 08    07
%     'd(rElbowZ , Pelvis)', ...          % 08    08
%     'd(rElbowZ , rWristX)', ...         % 08    09
%     'd(rElbowZ , rElbowZ)', ...         % 08    10
%     'd(rElbowZ , rShoulderX)', ...      % 08    11
%     'd(rShoulderX , Pelvis)', ...       % 08    12
%     'd(rShoulderX , rWristX)', ...      % 08    13
%     'd(rShoulderX , rElbowZ)', ...      % 08    14
%     'd(rShoulderX , rShoulderX)', ...   % 08    15
%     'v(Pelvis)', ...                    % 08      
%     'v(rShoulderX)', ...                % 08      
%     'v(rElbowZ)', ...                   % 08      
%     'v(rWristX)', ...                   % 08      
%     'v(lShoulderX)', ...                % 08      
%     'v(lElbowZ)', ...                   % 08      
%     'v(lWristX)', ...                   % 08     
%     'musc 1', ...                       % 08      
%     'musc 2', ...                       % 08      
%     'musc 3', ...                       % 08      
%     };

% 
Labels = {
    'JLength', ...                       % 01
    'JVelocity', ...                     % 01
    'JAcceleration', ...                 % 01
    'JJerk', ...                         % 01
    'TLength', ...                       % 01
    'TVelocity', ...                     % 01
    'TAcceleration', ...                 % 01
    'TJerk', ...                         % 01
    'd(Pelvis, Pelvis)', ...            % 04    00
    'd(Pelvis , rWristX)', ...          % 05    01
    'd(Pelvis , rElbowZ)', ...          % 06    02
    'd(Pelvis , rShoulderX)', ...       % 07    03
    'd(rWristX , Pelvis)', ...          % 08    04
    'd(rWristX , rWristX)', ...         % 08    05
    'd(rWristX , rElbowZ)', ...         % 08    06
    'd(rWristX , rShoulderX)', ...      % 08    07
    'd(rElbowZ , Pelvis)', ...          % 08    08
    'd(rElbowZ , rWristX)', ...         % 08    09
    'd(rElbowZ , rElbowZ)', ...         % 08    10
    'd(rElbowZ , rShoulderX)', ...      % 08    11
    'd(rShoulderX , Pelvis)', ...       % 08    12
    'd(rShoulderX , rWristX)', ...      % 08    13
    'd(rShoulderX , rElbowZ)', ...      % 08    14
    'd(rShoulderX , rShoulderX)'        
    };

FigHandle = figure('name', ['DEMONSTRATION : ' num2str(demo_id)], 'Position', [1000, 50, 1000, 1400]);

subplot(7,1,1)
bar( w_1' )
ylabel('Original Weights')

subplot(7,1,2)
bar( w_o' )
ylabel('Recovered Weights')

if plot_markers, % size(phi_mean) == nb_label,
    % set(gca,'XTickLabel',Labels)
    set(gca,'XTick',1:nb_label)
    RotateXLabel(90,Labels)
end

subplot(7,1,4)
bar( phi_demo )
% set(gca,'XTick',1:size(phi_demo,2))
% RotateXLabel(90,Labels)
ylabel('Phi demo')
subplot(7,1,5)
bar(phi_mean)
% set(gca,'XTick',1:size(phi_demo,2))
% RotateXLabel(90,Labels)
% bar(mean(deltas))
ylabel('Phi mean')
subplot(7,1,6)
bar( phi_variance )
% set(gca,'XTick',1:size(phi_demo,2))
% RotateXLabel(90,Labels)
ylabel('Phi var')
%axis([0 16 0 30])
subplot(7,1,7)
plot( costs )
hold on
plot( 1:size(costs,2), demo_cost*ones(size(costs,2)), 'r' )
ylabel('Cost of samples')


% phi_mean

% % histograms
% phi_entropy = zeros( 1, size( deltas , 2 ) );
% % figure
% for i=1:size( deltas, 2 ),
%     bins = min( minimus ):0.2:max( maximums );
%     [counts,binCenters] = hist(deltas(i,:),bins);
%     
% %     subplot(size( deltas, 2 ),1,i)
% %     plot( binCenters, counts );
%     
%     binWidth = diff(binCenters);
%     binWidth = [binWidth(end),binWidth]; % Replicate last bin width for first, which is indeterminate.
%     nz = counts>0; % Index to non-zero bins
%     frequency = counts(nz)/sum(counts(nz));
%     phi_entropy(i) = -sum(frequency.*( log(frequency./binWidth(nz)) ) );
% %     frequency
% %     frequency./binWidth(nz)
%     % sum(frequency)
% end

% figure
% bar( phi_entropy )
% axis([0 16 -1 3]);

% plot( frequency./binWidth(nz) )

% % figure
% % plot( sort(costs,'descend') )
% figure
% min_cost = min( costs );
% max_cost = max( costs );
% factor = 20;
% % bins = min_cost:(max_cost-min_cost)/100:max_cost;
% bins = 0:0.1:(factor);
% [counts,binCenters] = hist(costs,bins);
% frequency = counts./sum(counts);
% % subplot(2,1,1)
% plot( binCenters, frequency )
% hold on
% % subplot(2,1,2)
% % factor = sum(exp(-binCenters));
% plot( binCenters, exp(-binCenters)/factor  , 'r')
% axis([-1 factor 0 0.1] )
% sum( exp(-binCenters)/factor )
% factor
% % w_o*phi_demo'

function costs = delta_exponential_cost(w,deltas)

costs = zeros( 1, size( deltas, 1 ) );

for i=1:size( deltas ),
    % costs(i) = exp( -1.0 * w * deltas(i,:)' );
    costs(i) = w * deltas(i,:)';
end

function result = RotateXLabel(degrees,newlabels)

xtl = get(gca,'XTickLabel');
set(gca,'XTickLabel','');
lxtl = length(xtl);
if nargin>1
    lnl = length(newlabels);
    if lnl~=lxtl
        error('Number of new labels must equal number of old');
    end;
    xtl = newlabels;
end;

hxLabel=get(gca,'XLabel');
xLP=get(hxLabel,'Position');
y=xLP(2);
XTick=get(gca,'XTick');
y=repmat(y,length(XTick),1);
fs=get(gca,'fontsize');
hText=text(XTick,y,xtl,'fontsize',fs);
set(hText,'Rotation',degrees,'HorizontalAlignment','right');
