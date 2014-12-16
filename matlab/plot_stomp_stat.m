figure

% folder = '../launch_files/'
folder = '/home/jmainpri/Desktop/stomp_profiles/'

vel_0 = load([folder 'task_acc/stomp_vel_000.txt']);
vel_1 = load([folder 'task_acc/stomp_vel_001.txt']);
vel_2 = load([folder 'task_acc/stomp_vel_002.txt']);

xmin = 60;
xmax = 200;
ymin = 0;
ymax = 1000*1e-01;

subplot(3,1,1)
plot(vel_0)
axis([xmin xmax ymin ymax])
subplot(3,1,2)
plot(vel_1)
axis([xmin xmax ymin ymax])
subplot(3,1,3)
plot(vel_2)
axis([xmin xmax ymin ymax])

%%
vel_0 = load('../launch_files/stomp_vel_000.txt');
vel_1 = load('../launch_files/stomp_vel_001.txt');
vel_2 = load('../launch_files/stomp_vel_002.txt');
vel_3 = load('../launch_files/stomp_vel_003.txt');
vel_4 = load('../launch_files/stomp_vel_004.txt');
vel_5 = load('../launch_files/stomp_vel_005.txt');
vel_6 = load('../launch_files/stomp_vel_006.txt');

vel_7 = load('../launch_files/stomp_vel_007.txt');
vel_8 = load('../launch_files/stomp_vel_008.txt');
vel_9 = load('../launch_files/stomp_vel_009.txt');
vel_10 = load('../launch_files/stomp_vel_010.txt');
vel_11 = load('../launch_files/stomp_vel_011.txt');
vel_12 = load('../launch_files/stomp_vel_012.txt');
vel_13 = load('../launch_files/stomp_vel_013.txt');
vel_14 = load('../launch_files/stomp_vel_014.txt');
vel_15 = load('../launch_files/stomp_vel_015.txt');
vel_16 = load('../launch_files/stomp_vel_016.txt');
vel_17 = load('../launch_files/stomp_vel_017.txt');
vel_18 = load('../launch_files/stomp_vel_018.txt');
vel_19 = load('../launch_files/stomp_vel_019.txt');
vel_20 = load('../launch_files/stomp_vel_020.txt');
vel_21 = load('../launch_files/stomp_vel_021.txt');
vel_22 = load('../launch_files/stomp_vel_022.txt');

vel_0 = load('../launch_files/stomp_vel_000.txt');
vel_1 = load('../launch_files/stomp_vel_001.txt');
vel_2 = load('../launch_files/stomp_vel_002.txt');
vel_3 = load('../launch_files/stomp_vel_003.txt');
vel_4 = load('../launch_files/stomp_vel_004.txt');
vel_5 = load('../launch_files/stomp_vel_005.txt');
vel_6 = load('../launch_files/stomp_vel_006.txt');

acc_0 = load('../launch_files/stomp_acc_000.txt');
acc_1 = load('../launch_files/stomp_acc_001.txt');
acc_2 = load('../launch_files/stomp_acc_002.txt');
acc_3 = load('../launch_files/stomp_acc_003.txt');
acc_4 = load('../launch_files/stomp_acc_004.txt');
acc_5 = load('../launch_files/stomp_acc_005.txt');
acc_6 = load('../launch_files/stomp_acc_006.txt');

jerk_0 = load('../launch_files/stomp_jerk_000.txt');
jerk_1 = load('../launch_files/stomp_jerk_001.txt');
jerk_2 = load('../launch_files/stomp_jerk_002.txt');
jerk_3 = load('../launch_files/stomp_jerk_003.txt');
jerk_4 = load('../launch_files/stomp_jerk_004.txt');
jerk_5 = load('../launch_files/stomp_jerk_005.txt');
jerk_6 = load('../launch_files/stomp_jerk_006.txt');

xmin = 1;
xmax = 100;
ymin = 0;
ymax = 3*1e-01;

figure
subplot(6,1,1)
plot(vel_0)
axis([xmin xmax ymin ymax])
subplot(6,1,2)
plot(vel_1)
axis([xmin xmax ymin ymax])
subplot(6,1,3)
plot(vel_2)
axis([xmin xmax ymin ymax])
subplot(6,1,4)
plot(vel_3)
axis([xmin xmax ymin ymax])
subplot(6,1,5)
plot(vel_4)
axis([xmin xmax ymin ymax])
subplot(6,1,6)
plot(vel_5)
axis([xmin xmax ymin ymax])

figure
subplot(6,1,1)
plot(vel_7)
axis([xmin xmax ymin ymax])
subplot(6,1,2)
plot(vel_8)
axis([xmin xmax ymin ymax])
subplot(6,1,3)
plot(vel_9)
axis([xmin xmax ymin ymax])
subplot(6,1,4)
plot(vel_10)
axis([xmin xmax ymin ymax])
subplot(6,1,5)
plot(vel_11)
axis([xmin xmax ymin ymax])
subplot(6,1,6)
plot(vel_12)
axis([xmin xmax ymin ymax])

figure
subplot(6,1,1)
plot(vel_13)
axis([xmin xmax ymin ymax])
subplot(6,1,2)
plot(vel_14)
axis([xmin xmax ymin ymax])
subplot(6,1,3)
plot(vel_15)
axis([xmin xmax ymin ymax])
subplot(6,1,4)
plot(vel_16)
axis([xmin xmax ymin ymax])
subplot(6,1,5)
plot(vel_17)
axis([xmin xmax ymin ymax])
subplot(6,1,6)
plot(vel_18)
axis([xmin xmax ymin ymax])

figure
subplot(6,1,1)
plot(vel_19)
axis([xmin xmax ymin ymax])
subplot(6,1,2)
plot(vel_20)
axis([xmin xmax ymin ymax])
subplot(6,1,3)
plot(vel_21)
axis([xmin xmax ymin ymax])
subplot(6,1,4)
plot(vel_22)
axis([xmin xmax ymin ymax])

%%
% subplot(6,1,1)
% plot(vel_0)
% subplot(6,1,2)
% plot(vel_1)
% subplot(6,1,3)
% plot(vel_2)
% subplot(6,1,4)
% plot(vel_3)
% subplot(6,1,5)
% plot(vel_4)
% subplot(6,1,6)
% plot(vel_5)

% subplot(6,1,1)
% plot(acc_0)
% subplot(6,1,2)
% plot(acc_1)
% subplot(6,1,3)
% plot(acc_2)
% subplot(6,1,4)
% plot(acc_3)
% subplot(6,1,5)
% plot(acc_4)
% subplot(6,1,6)
% plot(acc_5)

% figure
% subplot(6,1,1)
% plot(jerk_0)
% subplot(6,1,2)
% plot(jerk_1)
% subplot(6,1,3)
% plot(jerk_2)
% subplot(6,1,4)
% plot(jerk_3)
% subplot(6,1,5)
% plot(jerk_4)
% subplot(6,1,6)
% plot(jerk_5)

% subplot(6,1,3)
% plot(acc_0)
% subplot(6,1,4)
% plot(acc_1)
% 
% subplot(6,1,5)
% plot(jerk_0)
% subplot(6,1,6)
% plot(jerk_1)