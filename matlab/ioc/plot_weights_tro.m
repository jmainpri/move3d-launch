function plot_weights_tro() 

w_icra = load('vectors.txt');

% Set move3d and matlab working directories
move3d_base_dir = '/usr/local/jim_local/Dropbox/move3d/';
move3d_dir = [move3d_base_dir 'move3d-launch/'];
matlab_dir = [move3d_dir 'matlab/'];
weights_tmp = [move3d_dir 'matlab/move3d_tmp_data_human_trajs/tmp_weights/'];

nb_label = 36;

weights(i,r,:) = load([weights_tmp 'spheres_weights_', ...
            num2str(samples(r),'%03d'), '_', num2str(ioc_regularizer), '_.txt'])

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
    'Config SPINE 0', ...          % 08    04
    'Config SPINE 1', ...         % 08    05
    'Config SPINE 2', ...         % 08    06
    'Config ARM RIGTH SHOULDER 0', ...      % 08    07
    'Config ARM RIGTH SHOULDER 1', ...          % 08    08
    'Config ARM RIGTH SHOULDER 2', ...         % 08    09
    'Config ARM RIGTH ELBOW 0', ...         % 08    10
    'Config ARM RIGTH ELBOW 1', ...      % 08    11
    'Config ARM RIGTH ELBOW 2', ...       % 08    12
    'Config ARM RIGTH WRIST 0', ...      % 08    13
    'Config ARM RIGTH WRIST 1', ...      % 08    14
    'Config ARM RIGTH WRIST 2'        
    };

FigHandle = figure('name', ['WEIGHTS']);



subplot(2,1,1)
h = bar( mean(w_icra)', 'w' );
axis([0 24 0 300])
set(h,'LineWidth', 2);
hold on
errorbar( 1:nb_label, mean(w_icra)', std(w_icra)','xk')
ylabel('Recovered Weights')

set(gca,'XTick',1:nb_label)
RotateXLabel(90,Labels)


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