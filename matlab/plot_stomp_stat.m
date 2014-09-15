figure

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

subplot(6,1,1)
plot(vel_0)
subplot(6,1,2)
plot(vel_1)
subplot(6,1,3)
plot(vel_2)
subplot(6,1,4)
plot(vel_3)
subplot(6,1,5)
plot(vel_4)
subplot(6,1,6)
plot(vel_5)

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