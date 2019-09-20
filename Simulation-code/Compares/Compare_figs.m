% compare results

clc
close all
clear
SetDefaults

% load cone angle and kinematic figures
% s1 = load('Compare1A.mat');
% s2 = load('Compare1C.mat');
% savename = 'Compare_1';
% s1 = load('Compare2A.mat');
% s2 = load('Compare2B.mat');
% savename = 'Compare_2';
s1 = load('Compare3A.mat');
s2 = load('Compare3B.mat');
savename = 'Compare_3';

% load variable
x1 = s1.x;
t1 = s1.t;
x2 = s2.x;
t2 = s2.t;

% plot angle
fig1 = figure;
hold on
plot(t1, x1(:, 1)*180/pi, 'DisplayName', sprintf('CA = %d deg', s1.ca));
plot(t2, x2(:, 1)*180/pi, 'DisplayName', 'Kinematics');
grid on
xlim([0, 120]);
ylabel('Angle [deg]');
xlabel('Time [s]');
legend('location', 'southeast');
saveas(fig1, [savename, '_angle.fig']);
saveas(fig1, [savename, '_angle.jpg']);
saveas(fig1, [savename, '_angle.pdf']);
saveas(fig1, [savename, '_angle.emf']);

% plot angle rate
fig2 = figure;
hold on
plot(t1, x1(:, 2)*180/pi, 'DisplayName', sprintf('CA = %d deg', s1.ca));
plot(t2, x2(:, 2)*180/pi, 'DisplayName', 'Kinematics');
grid on
xlim([0, 120]);
ylabel('Angular velocity [deg/s]');
xlabel('Time [s]');
legend('location', 'southeast');
saveas(fig2, [savename, '_angledot.fig']);
saveas(fig2, [savename, '_angledot.jpg']);
saveas(fig2, [savename, '_angledot.pdf']);
saveas(fig2, [savename, '_angledot.emf']);

% plot mass positions
fig3 = figure;
subplot(2, 2, 1)
hold on
title(sprintf('CA = %d deg', s1.ca))
plot(t1, x1(:, 3), 'DisplayName', '$r_1$');
plot(t1, x1(:, 5), 'DisplayName', '$r_3$');
grid on
xlim([0, 120]);
ylabel('Position [m]');
legend('location', 'southeast');

subplot(2, 2, 3)
hold on
plot(t1, x1(:, 4), 'DisplayName', '$r_2$');
plot(t1, x1(:, 6), 'DisplayName', '$r_4$');
grid on
xlim([0, 120]);
ylabel('Position [m]');
xlabel('Time [s]');
legend('location', 'southeast');

subplot(2, 2, 2)
hold on
title('Kinematics')
plot(t2, x2(:, 3), 'DisplayName', '$r_1$');
plot(t2, x2(:, 5), 'DisplayName', '$r_3$');
grid on
xlim([0, 120]);
legend('location', 'southeast');

subplot(2, 2, 4)
hold on
plot(t2, x2(:, 4), 'DisplayName', '$r_2$');
plot(t2, x2(:, 6), 'DisplayName', '$r_4$');
grid on
xlim([0, 120]);
xlabel('Time [s]');
legend('location', 'southeast');
saveas(fig3, [savename, '_masses.fig']);
saveas(fig3, [savename, '_masses.jpg']);
saveas(fig3, [savename, '_masses.pdf']);
saveas(fig3, [savename, '_masses.emf']);

% calculate movement of masses
m1 = s1.m;
ma1 = s1.ma;
n1 = length(t1);
d1 = zeros(n1, 2);
w1 = d1;
p1 = d1;
v1 = d1;
for i1 = 2:n1
    tta = x1(i1, 1);     % rad, angle
    ttad = x1(i1, 2);    % rad/s, angle rate
    indx1 = 3;
    indx2 = 1;
    v1(i1, indx2) = (x1(i1, indx1) - x1(i1 - 1, indx1))/(t1(i1) - t1(i1 - 1));
    d1(i1, indx2) = abs((x1(i1, indx1) - x1(i1 - 1, indx1))) + d1(i1 - 1, indx2);
    p1(i1, indx2) = abs(ma1(i1, indx2)*v1(i1, indx2));
    w1(i1, indx2) = w1(i1 - 1, indx2) + p1(i1, indx2)*(t1(i1) - t1(i1 - 1));
    indx1 = 5;
    indx2 = 2;
    v1(i1, indx2) = (x1(i1, indx1) - x1(i1 - 1, indx1))/(t1(i1) - t1(i1 - 1));
    d1(i1, indx2) = abs((x1(i1, indx1) - x1(i1 - 1, indx1))) + d1(i1 - 1, indx2);
    p1(i1, indx2) = abs(ma1(i1, indx2)*v1(i1, indx2));
    w1(i1, indx2) = w1(i1 - 1, indx2) + p1(i1, indx2)*(t1(i1) - t1(i1 - 1));
end
ma2 = s2.ma;
n2 = length(t2);
d2 = zeros(n2, 2);
w2 = d2;
p2 = d2;
v2 = d2;
for i2 = 2:n2
    tta = x2(i2, 1);     % rad, angle
    ttad = x2(i2, 2);    % rad/s, angle rate
    indx1 = 3;
    indx2 = 1;
    v2(i2, indx2) = (x2(i2, indx1) - x2(i2 - 1, indx1))/(t2(i2) - t2(i2 - 1));
    d2(i2, indx2) = abs((x2(i2, indx1) - x2(i2 - 1, indx1))) + d2(i2 - 1, indx2);
    p2(i2, indx2) = abs(ma2(i2, indx2)*v2(i2, indx2));
    w2(i2, indx2) = w2(i2 - 1, indx2) + p2(i2, indx2)*(t2(i2) - t2(i2 - 1));
    indx1 = 5;
    indx2 = 2;
    v2(i2, indx2) = (x2(i2, indx1) - x2(i2 - 1, indx1))/(t2(i2) - t2(i2 - 1));
    d2(i2, indx2) = abs((x2(i2, indx1) - x2(i2 - 1, indx1))) + d2(i2 - 1, indx2);
    p2(i2, indx2) = abs(ma2(i2, indx2)*v2(i2, indx2));
    w2(i2, indx2) = w2(i2 - 1, indx2) + p2(i2, indx2)*(t2(i2) - t2(i2 - 1));
end

fig4 = figure;
hold on
subplot(1, 2, 1)
hold on
title(sprintf('CA = %d deg', s1.ca))
plot(t1, d1(:, 1), 'DisplayName', '$r_1$');
plot(t1, d1(:, 2), 'DisplayName', '$r_3$');
grid on
xlim([0, 120]);
xlabel('Time [s]');
set(gca, 'XTick', 0:30:120);
ylabel('Distance traveled [m]');
legend('location', 'northwest');
ylim1 = ylim;

subplot(1, 2, 2)
hold on
title('Kinematics');
plot(t2, d2(:, 1), 'DisplayName', '$r_1$');
plot(t2, d2(:, 2), 'DisplayName', '$r_3$');
grid on
xlim([0, 120]);
set(gca, 'XTick', 0:30:120);
xlabel('Time [s]');
legend('location', 'northwest');
ylim2 = ylim;

ylimz = [0, max([ylim1, ylim2])];
ylim(ylimz);
subplot(1, 2, 1)
ylim(ylimz);
saveas(fig4, [savename, '_dist.fig']);
saveas(fig4, [savename, '_dist.jpg']);
saveas(fig4, [savename, '_dist.pdf']);
saveas(fig4, [savename, '_dist.emf']);

% mass velocity
fig5 = figure;
subplot(1, 2, 1);
hold on
title(sprintf('CA = %d deg', s1.ca))
plot(t1, v1(:, 1), 'DisplayName', '$\dot{r}_1$');
plot(t1, v1(:, 2), 'DisplayName', '$\dot{r}_3$');
grid on
xlim([0, 120]);
xlabel('Time [s]');
set(gca, 'XTick', 0:30:120);
ylabel('Velocoiy [m/s]');
legend('location', 'northwest');
ylim1 = ylim;

subplot(1, 2, 2)
hold on
title('Kinematics');
plot(t2, v2(:, 1), 'DisplayName', '$\dot{r}_1$');
plot(t2, v2(:, 2), 'DisplayName', '$\dot{r}_3$');
grid on
xlim([0, 120]);
set(gca, 'XTick', 0:30:120);
xlabel('Time [s]');
legend('location', 'northwest');
ylim2 = ylim;

ylimz = [min([ylim1, ylim2]), max([ylim1, ylim2])];
ylim(ylimz);
subplot(1, 2, 1)
ylim(ylimz);
saveas(fig5, [savename, '_vel.fig']);
saveas(fig5, [savename, '_vel.jpg']);
saveas(fig5, [savename, '_vel.pdf']);
saveas(fig5, [savename, '_vel.emf']);





% power
fig6 = figure;
subplot(1, 2, 1);
hold on
title(sprintf('CA = %d deg', s1.ca))
plot(t1, p1(:, 1), 'DisplayName', '$P_1$');
plot(t1, p1(:, 2), 'DisplayName', '$P_3$');
grid on
xlim([0, 120]);
xlabel('Time [s]');
set(gca, 'XTick', 0:30:120);
ylabel('Power [W]');
legend('location', 'northwest');
ylim1 = ylim;

subplot(1, 2, 2)
hold on
title('Kinematics');
plot(t2, p2(:, 1), 'DisplayName', '$P_1$');
plot(t2, p2(:, 2), 'DisplayName', '$P_3$');
grid on
xlim([0, 120]);
set(gca, 'XTick', 0:30:120);
xlabel('Time [s]');
legend('location', 'northwest');
ylim2 = ylim;

ylimz = [min([ylim1, ylim2]), max([ylim1, ylim2])];
ylim(ylimz);
subplot(1, 2, 1)
ylim(ylimz);
saveas(fig6, [savename, '_pwr.fig']);
saveas(fig6, [savename, '_pwr.jpg']);
saveas(fig6, [savename, '_pwr.pdf']);
saveas(fig6, [savename, '_pwr.emf']);





% work
fig7 = figure;
subplot(1, 2, 1);
hold on
title(sprintf('CA = %d deg', s1.ca))
plot(t1, w1(:, 1), 'DisplayName', '$W_1$');
plot(t1, w1(:, 2), 'DisplayName', '$W_3$');
grid on
xlim([0, 120]);
xlabel('Time [s]');
set(gca, 'XTick', 0:30:120);
ylabel('Work [J]');
legend('location', 'northwest');
ylim1 = ylim;

subplot(1, 2, 2)
hold on
title('Kinematics');
plot(t2, w2(:, 1), 'DisplayName', '$W_1$');
plot(t2, w2(:, 2), 'DisplayName', '$W_3$');
grid on
xlim([0, 120]);
set(gca, 'XTick', 0:30:120);
xlabel('Time [s]');
legend('location', 'northwest');
ylim2 = ylim;

ylimz = [min([ylim1, ylim2]), max([ylim1, ylim2])];
ylim(ylimz);
subplot(1, 2, 1)
ylim(ylimz);
saveas(fig7, [savename, '_work.fig']);
saveas(fig7, [savename, '_work.jpg']);
saveas(fig7, [savename, '_work.pdf']);
saveas(fig7, [savename, '_work.emf']);