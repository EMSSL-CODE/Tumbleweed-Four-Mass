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
runfiles = {'massvel_0p05mps';
    'massvel_0p10mps';
    'massvel_0p15mps';
    'massvel_0p20mps';
    'massvel_0p25mps';
    'massvel_0p30mps';
    'massvel_0p35mps';
    'massvel_0p40mps';
    'massvel_0p45mps';
    'massvel_0p50mps'};
    % 'massvel_0p55mps';
    % 'massvel_0p60mps';
    % 'massvel_0p65mps'};
bindir = 'massvar';

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
    mvv(i1) = mv;
    
    % get rover velocity history, calculate things
    s1 = load(fullfile(bindir, savename));
    
    % plot history
    figure(f1)
    hold on
    plot(s1.tme, s1.x(:, 2)*180/pi)
    % lgnd{i1} = sprintf('mv = %0.2f [m/s]', mvv(i1));
    lgnd{i1} = sprintf('%0.2f [m/s]', mvv(i1));
    
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
hold on
xlabel('Time [s]');
ylabel('Rover speed [deg/s]');
grid on
legend(lgnd, 'location', 'southeast');
set(gca, 'FontSize', fs);
savefig(gcf, 'AngVel-vs-time.fig');
print('AngVel-vs-time', '-dpdf');
print('AngVel-vs-time', '-dpng');
% keyboard




figure(f2);
hold on
plot(mvv, fsv*180/pi, '-o');
xlabel('Mass velocity [m/s]');
ylabel('Rover speed [deg/s]');
grid on
% legend(lgnd);
set(gca, 'FontSize', fs);

figure(f3);
hold on
plot(mvv, rtv, '-o');
xlabel('Mass velocity [m/s]');
ylabel('Rover rise time [s]');
grid on
% legend(lgnd);
set(gca, 'FontSize', fs);

figure(f4);
hold on
plot(mvv, stv, '-o');
xlabel('Mass velocity [m/s]');
ylabel('Rover settling time [s]');
grid on
% legend(lgnd);
set(gca, 'FontSize', fs);