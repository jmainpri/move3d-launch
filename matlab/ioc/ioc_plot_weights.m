function result = ioc_plot_weights()

% Set move3d and matlab working directories
move3d_base_dir = '/usr/local/jim_local/Dropbox/move3d/';
move3d_dir = [move3d_base_dir 'move3d-launch/'];
matlab_dir = [move3d_dir 'matlab/'];

% SET MOCAP SPLITS

loo_splits = [];
loo_splits = [loo_splits ; '[0444-0585]'];
loo_splits = [loo_splits ; '[0446-0578]'];
loo_splits = [loo_splits ; '[0489-0589]'];
loo_splits = [loo_splits ; '[0525-0657]'];
loo_splits = [loo_splits ; '[0780-0871]'];
loo_splits = [loo_splits ; '[1537-1608]'];
loo_splits = [loo_splits ; '[2711-2823]'];

% GENERATE WEIGHT VECTORS REPLAN  ----------------------------------------

cd( matlab_dir );

nb_label = 36;

w_icra = zeros(size(loo_splits,1),nb_label);
    
for i=1:size(loo_splits),
      
    % save(['results_current/tmp_results_replan/resu_human_motion_replan_' loo_splits(i,:) '.mat'],'results');
    % save(['results_current/tmp_results_replan/feat_human_motion_replan_' loo_splits(i,:) '.mat'],'feat_count');
    display(['load ' num2str(i)])
    a = load(['results_current/tmp_results_noreplan/' ...
        'weig_human_motion_noreplan_' loo_splits(i,:) '.mat']);
    w = squeeze(a.recovered_weights);
    %filename = [weights_tmp loo_splits(i,:) '_spheres_weights_700.txt'];
    %csvwrite(filename, w');
    w_icra(i,:) = w'
end

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
    'd(rShoulderX , rShoulderX)', ...
    'CONFIG INDEX SPINE 0', ...          % 08    04
    'CONFIG INDEX SPINE 1', ...         % 08    05
    'CONFIG INDEX SPINE 2', ...         % 08    06
    'CONFIG INDEX ARM RIGTH SHOULDER 0', ...      % 08    07
    'CONFIG INDEX ARM RIGTH SHOULDER 1', ...          % 08    08
    'CONFIG INDEX ARM RIGTH SHOULDER 2', ...         % 08    09
    'CONFIG INDEX ARM RIGTH ELBOW 0', ...         % 08    10
    'CONFIG INDEX ARM RIGTH ELBOW 1', ...      % 08    11
    'CONFIG INDEX ARM RIGTH ELBOW 2', ...       % 08    12
    'CONFIG INDEX ARM RIGTH WRIST 0', ...      % 08    13
    'CONFIG INDEX ARM RIGTH WRIST 1', ...      % 08    14
    'CONFIG INDEX ARM RIGTH WRIST 2'        
    };

FigHandle = figure('name', ['WEIGHTS']);

subplot(2,1,1)
h = bar( mean(w_icra)', 'w' );
axis([0 nb_label+1 0 300])
set(h,'LineWidth', 2);
hold on
errorbar( 1:nb_label, mean(w_icra)', std(w_icra)','xk')
ylabel('Recovered Weights')

% h = bar( w_icra(1,:)', 'b' );

set(gca,'XTick',1:nb_label)
RotateXLabel(90,Labels)

saveas(FigHandle, 'test', 'pdf')


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
