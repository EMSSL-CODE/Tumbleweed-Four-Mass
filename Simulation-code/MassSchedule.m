% Script to understand the requirement of mass travel as a function of
% tumbleweed parameters
% CDY
% 07-20-2019

% preamble
clc
close all
clear
SetDefaults;

% parameters
paramfile = 'sp_70_ca_15_Run1';
eval(paramfile);
% R = 0.5000;         % [m] radius
% mv = 0.2000;        % [m/s] mass velocity
% m = 0.3000;         % [kg] mass mass
% mCH = 14.8090;      % [kg] chassis mass
% UL = 0.3621;
% LL = 0.2000;
rtravel = UL - LL;
mT = mCH + 4*m;

theta = 0:5:360;    % [deg] angle
theta = theta;
theta_off = 90;      % [deg] offset from horizontal
nomr = rtravel*m/mT;        % r_CM/B magnitude
% nomr = 0;
yCM = nomr*cosd(theta_off);   % O frame yCM
zCM = nomr*sind(theta_off);   % O frame zCM

% calculate parameters
D = UL + LL;    % max of r1 + min of r3 = distance between masses
% old eqns
% r1 = mT.*yCM.*cosd(theta)./(2*m) + D./2;    
% r3 = -mT.*zCM.*sind(theta)./(2*m) + D./2;
% new eqns
r1 = mT.*(yCM.*cosd(theta) + zCM.*sind(theta))./(2*m) + D./2;
r3 = mT.*(zCM.*cosd(theta) - yCM.*sind(theta))./(2*m) + D./2;
r2 = r1 - D;
r4 = r3 - D;
r_CM_B_By = (m/mT)*(r1 + r3);

angvel = 90;    % deg/s
angvel = angvel*pi/180;
v1 = angvel*mT.*(zCM.*cosd(theta) - yCM.*sind(theta))./(2*m);
v3 = angvel*mT.*(yCM.*cosd(theta) + zCM.*sind(theta))./(2*m);

% plots
fig1 = figure;
hold on
% plot(theta, r1./R, 'DisplayName', '$r_1$');
% plot(theta, r3./R, 'DisplayName', '$r_3$');
% plot(theta, r2./R, 'DisplayName', '$r_2$');
% plot(theta, r4./R, 'DisplayName', '$r_4$');
% plot(theta, r1*0 + UL/R, 'r--', 'DisplayName', 'UL');
% plot(theta, r1*0 + LL/R, 'r--', 'DisplayName', 'LL');
% xlabel('$\theta [deg]$');
% ylabel('$r_{mass} / r_{rover}$');
% grid on
% % xlim([0, 360]);
% % ylim([LL/R, UL/R]);

plot(theta, r1, 'DisplayName', '$r_1$');
plot(theta, r3, 'DisplayName', '$r_3$');
plot(theta, r2, 'DisplayName', '$r_2$');
plot(theta, r4, 'DisplayName', '$r_4$');
plot(theta, r1*0 + UL, 'r--', 'DisplayName', 'UL');
plot(theta, r1*0 + LL, 'r--', 'DisplayName', 'LL');
xlabel('$\theta [deg]$');
ylabel('$r_{mass} / r_{rover}$');
grid on
% xlim([0, 360]);
% ylim([LL/R, UL/R]);

% set(gca, 'XTick', 0:45:360);
legend('location', 'southeast');


% 
% % compare with other function
% for i1 = 1:length(theta)
%     [r1, r2, r3, r4, r1d, r2d, r3d, r4d, r1dd, r2dd, r3dd, r4dd] = ...
%         GetMassPositions_revB(x, LL, UL, mv, t, sp, kP_vel, m, mT);
%     r1v(i1) = r1;
%     r2v(i1) = r2;
%     r3v(i1) = r3;
%     r4v(i1) = r4;


fig2 = figure;
hold on
plot(theta, v1, 'DisplayName', '$v_1$');
plot(theta, v3, 'DisplayName', '$v_3$');
xlabel('$\theta [deg]$');
ylabel('Velocity [m/s]');
grid on
legend('location', 'southeast');