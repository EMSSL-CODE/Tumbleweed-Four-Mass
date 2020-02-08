% code to process and make velocity plots

% preamble
clc
close all
clear
fclose('all');

% figure stuff
set(groot, 'defaultFigureColor', 'w');
set(groot, 'defaultAxesTickLabelInterpreter', 'latex');
set(groot, 'defaultColorbarTickLabelInterpreter', 'latex');
set(groot, 'defaultGraphplotInterpreter', 'latex');
set(groot, 'defaultLegendInterpreter', 'latex');
set(groot, 'defaultPolaraxesTickLabelInterpreter', 'latex');
set(groot, 'defaultTextInterpreter', 'latex');
pp = [0, 0, 3, 3];
fs = 8;
set(groot, 'defaultFigureUnits', 'inches');
mrkrs = {'o', '^', '*', 'v', '.', '<', 's', '>', 'd', ...
    'o', '^', '*', 'v', '.', '<', 's', '>', 'd'};

% filenames
runfiles = {'crr_12';
    'crr_11';
    'crr_5';
    'crr_13';
    'crr_1';
    'crr_14';
    'crr_6';
    'crr_15';
    'crr_7';
    'crr_16';
    'crr_8'};
bindir = 'crr';

% load and plot
f1 = figure;    % history
set(gcf, 'PaperUnits', 'inches');
set(gcf, 'PaperSize', pp(3:4));
set(gcf, 'PaperPosition', pp);
set(gcf, 'Position', pp);
f2 = figure;    % final velocity
set(gcf, 'PaperSize', pp(3:4));
set(gcf, 'PaperPosition', pp);
set(gcf, 'Position', pp);
f3 = figure;    % rise time
set(gcf, 'PaperSize', pp(3:4));
set(gcf, 'PaperPosition', pp);
set(gcf, 'Position', pp);
f4 = figure;    % settling time
set(gcf, 'PaperSize', pp(3:4));
set(gcf, 'PaperPosition', pp);
set(gcf, 'Position', pp);
% f5 = figure;

mvv = NaN(length(runfiles), 1); 
fsv = mvv;
rtv = mvv;
stv = mvv;
for i1 = 1:length(runfiles)
    
    % eval runfile, get save name, mass vel, etc. 
    eval(runfiles{i1});
    % mvv(i1) = mv;
    mvv(i1) = Crr0;
    
    % get rover velocity history, calculate things
    s1 = load(fullfile(bindir, savename));
    
    % plot history
    figure(f1)
    hold on
    subplot(1, 2, 1)
    plot(s1.tme, s1.x(:, 2)*180/pi)
    % lgnd{i1} = sprintf('mv = %0.2f [m/s]', mvv(i1));
    % lgnd{i1} = sprintf('%0.2f [m/s]', mvv(i1));
    lgnd{i1} = sprintf('%0.4f', mvv(i1));
    
    % plot final velocity
    angvel = mean(s1.x(end-100:end, 2));    % get average final velocity
    fsv(i1) = angvel;
    
    % get control stats
    s2 = stepinfo(s1.x(:, 2), s1.tme); 
    rtv(i1) = s2.RiseTime;
    stv(i1) = s2.SettlingTime;
    
    % keyboard
end

figure(f1);
subplot(1, 2, 1)
hold on
xlabel('Time [s]');
ylabel('Rover speed [deg/s]');
grid on
legend(lgnd, 'location', 'southeast');
set(gca, 'FontSize', fs);
% savefig(gcf, 'AngVel-vs-time.fig');
% print('AngVel-vs-time', '-dpdf');
% print('AngVel-vs-time', '-dpng');
% keyboard

subplot(1, 2, 2)
% set(gcf, 'PaperUnits', 'inches');
% set(gcf, 'PaperSize', pp(3:4));
% set(gcf, 'PaperPosition', pp);
% set(gcf, 'Position', pp);
hold on
yyaxis left
plot(mvv, fsv*180/pi, '-o');
ylim([0, 200])
xlabel('Crr');
ylabel('Rover speed [deg/s]');
grid on
yyaxis right
plot(mvv, rtv, '-s');
ylabel('Rover rise time [s]');
legend({'Rover Speed', 'Rover Rise Time'}, 'location', 'northeast');
set(gca, 'FontSize', fs);




figure(f2);
hold on
plot(mvv, fsv*180/pi, '-o');
xlabel('Crr');
ylabel('Rover speed [deg/s]');
grid on
% legend(lgnd);
set(gca, 'FontSize', fs);

figure(f3);
hold on
plot(mvv, rtv, '-o');
xlabel('Crr');
ylabel('Rover rise time [s]');
grid on
% legend(lgnd);
set(gca, 'FontSize', fs);

figure(f4);
hold on
plot(mvv, stv, '-o');
xlabel('Crr');
ylabel('Rover settling time [s]');
grid on
% legend(lgnd);
set(gca, 'FontSize', fs);


figure
set(gcf, 'PaperUnits', 'inches');
set(gcf, 'PaperSize', pp(3:4));
set(gcf, 'PaperPosition', pp);
set(gcf, 'Position', pp);
hold on
yyaxis left
plot(mvv, fsv*180/pi, '-o');
ylim([0, 200])
xlim([-0.00001, 0.00501]);
set(gca, 'YTick', 0:25:200);
xlabel('Crr');
ylabel('Rover speed [deg/s]');
grid on
yyaxis right
plot(mvv, rtv, '-s');
ylim([75, 275]);
set(gca, 'YTick', 75:25:275);
ylabel('Rover rise time [s]');
legend({'Rover Speed', 'Rover Rise Time'}, 'location', 'northeast');
set(gca, 'FontSize', fs);
savefig(gcf, 'Speed-RiseTime-Crr.fig');
print('Speed-RiseTime-Crr', '-dpdf');
print('Speed-RiseTime-Crr', '-dpng');


% % % % %
close all
% Make normal force plot for later
paramfile = 'crr_1';
eval(paramfile);
s1 = load(fullfile(bindir, savename));
s2 = s1.x(:, 1)/(2*pi); % angle in the form of # of rotations
s3 = sum(s2 <= floor(s2(end) - 2)) - 3; % last two full rotations
tta_rot = s2(s3:end, 1);
% m1_rot = s1.x(s3:end, 3);
N_rot = s1.N(s3:end);
rotq = ceil(tta_rot(1)):0.005:ceil(tta_rot(1)) + 2;
m1 = interp1(tta_rot, s1.x(s3:end, 3), rotq, 'spline');
m3 = interp1(tta_rot, s1.x(s3:end, 5), rotq, 'spline');
Nq = interp1(tta_rot, N_rot, rotq, 'spline');
rotq = (rotq - rotq(1))*360;    % convert from rotation to degrees
xlz = [0, 360];
% rotq = (rotq)*360;
% xlz = rotq(1)*[1, 1] + [0, 360]; 
% keyboard


figure
set(gcf, 'PaperUnits', 'inches');
set(gcf, 'PaperSize', pp(3:4));
set(gcf, 'PaperPosition', pp);
set(gcf, 'Position', pp);
hold on
% plot(s1.t, s1.N)
yyaxis left
% plot(s1.x(:, 1)*180/pi, s1.N)
% xlz = s1.x(end, 1)*180/pi + [-360, 0];
plot(rotq, Nq)
% ylim([208.94, 209.20])

% xlz = [0, 360*1];
xlim(xlz);    % plot last two full revolutions
xlabel('Angle [deg]');
ylabel('Normal force [N]');
grid on
ylim([208.90, 209.15]);
yyaxis right
% add mass positon for m1
hold on
% plot(s1.x(:, 1)*180/pi, s1.x(:, 3));
plot(rotq, m1)
plot(rotq, m3)
ylabel('Mass position [m]');
grid on
xlim(xlz);
ylz = [0.20, 0.60];
set(gca, 'XTick', 0:60:360);
ylim(ylz);
set(gca, 'YTick', linspace(ylz(1), ylz(2), 6));
h1 = legend({'Normal force', 'Mass 1', 'Mass 3'}, 'location', 'northeast');
set(gcf, 'position', [10.8512    3.3095    3.0000    3.0000]);
set(h1, 'position', [0.4594    0.7438    0.3898    0.1524]);
set(gca, 'FontSize', fs);
savefig(gcf, 'N-ang-nom.fig');
print('N-ang-nom', '-dpdf');
print('N-ang-nom', '-dpng');