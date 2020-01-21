% simulate downhill testing
%
% revA = CDY @ 2019-07-11
% revB = CDY @ 2019-07-20 - compare cone angle and kinematics

clc
close all
clear
SetDefaults

%% 1 Comparing Exp and Sim (Exp Mass Pos I/P for Sim O/P)
% angular velocity sims
%bindir = 'Compares';

%paramfile = 'Compare_sp_70_ca_15_A';  % run 1, revB
% paramfile = 'Compare_sp_70_ca_15_C';  % run 1, revC controlled
% paramfile = 'Compare_sp_30_ca_5_A';  % run 2, revA
% paramfile = 'Compare_sp_30_ca_5_B';  % run 2, revB
% paramfile = 'Compare_sp_50_ca_20_A';  % run 3, revA
% paramfile = 'Compare_sp_30_t1_B';  % run 3, revB
%% 2  MM to CM Sims only
%bindir = 'MM_CM_Sims';

% paramfile = 'MMCM_p005_paramfile';
% paramfile = 'MMCM_p010_paramfile';
% paramfile = 'MMCM_p015_paramfile';
% paramfile = 'MMCM_p020_paramfile';
% paramfile = 'MMCM_p025_paramfile';
% paramfile = 'MMCM_p030_paramfile';
% paramfile = 'MMCM_p035_paramfile';
% paramfile = 'MMCM_p040_paramfile';
% paramfile = 'MMCM_p045_paramfile';
% paramfile = 'MMCM_p050_paramfile';

%% 3 Rover Size Sims

%bindir = 'Rover_Size_Sims';

% paramfile = 'Dia_1p00_paramfile';
%  paramfile = 'Dia_1p25_paramfile';
%  paramfile = 'Dia_1p50_paramfile';
%  paramfile = 'Dia_1p75_paramfile';
%  paramfile = 'Dia_2p00_paramfile';

%% 4 Variable Setpoint Study

% 4.a) Braking 

bindir = 'Braking';

% paramfile = 'braking_SP_30_paramfile';
% paramfile = 'braking_SP_40_paramfile';
% paramfile = 'braking_SP_50_paramfile';
% paramfile = 'braking_SP_60_paramfile';
% paramfile = 'braking_SP_70_paramfile';
% paramfile = 'braking_SP_80_paramfile';
% paramfile = 'braking_SP_90_paramfile';
 paramfile = 'braking_SP_100_paramfile';



% 4.b) Variable setpoint 

% bindir = 'Variable_SP';
% 
% paramfile = 'Sine_Wave_T200';
%y = 50*sin(2*pi*t/200);
%y = 50*sin(2*pi*t/400);
%y = 50*sin(2*pi*t/600);
%y = 50*sin(2*pi*t/800);
%y = 50*sin(2*pi*t/1000);


%% 5 maximum mass velocity study
% Christopher D. Yoder
% 2020-01-09
% I forgot how to run this code. We should write a readme :/
%

bindir = 'massvar';
% paramfile = 'massvel_01p00mps';
% paramfile = 'massvel_0p10mps';
% paramfile = 'massvel_0p20mps';
% paramfile = 'massvel_0p30mps';
% paramfile = 'massvel_0p40mps';
% paramfile = 'massvel_0p50mps';
% paramfile = 'massvel_0p05mps';
% paramfile = 'massvel_0p15mps';
paramfile = 'massvel_0p25mps';
% paramfile = 'massvel_0p35mps';
% paramfile = 'massvel_0p45mps';
% paramfile = 'massvel_0p55mps';
% paramfile = 'massvel_0p60mps';
% paramfile = 'massvel_0p65mps';

% paramfile = 'mv_0p30mps_oa180';
% paramfile = 'mv_0p30mps_oa165';
% paramfile = 'mv_0p30mps_oa150';
% paramfile = 'mv_0p30mps_oa135';
% paramfile = 'mv_0p30mps_oa120';
% paramfile = 'mv_0p30mps_oa105';
% paramfile = 'mv_0p30mps_oa90';

%% 6 Crr study
bindir = 'Crr';
% paramfile = 'crr_2';            % Crr = 0.005; Ewdin hard ground
% paramfile = 'crr_3';            % Crr = 0.05; Ewdin middle
% paramfile = 'crr_4';            % Crr = 0.1; Ewdin middle

% paramfile = 'crr_12';               % crr = 0.0001
% paramfile = 'crr_11';               % crr = 0.0005
% paramfile = 'crr_5';              % Crr = 0.001; Less
% paramfile = 'crr_1';              % Crr = 0.002 = Crr0
% paramfile = 'crr_6';              % Crr = 0.003; Less
% paramfile = 'crr_7';            % Crr = 0.004; Less
% paramfile = 'crr_8';            % Crr = 0.005; Less
% paramfile = 'crr_9';            % Crr = 0.006; Less
% paramfile = 'crr_10';            % Crr = 0.007; Less


% leave everything below this alone! -CDY
% -----------------------------------------------------------------------

% check bin
if exist(bindir, 'dir') ~= 7
    mkdir(bindir);
end

% set the stage
expCname = 'NaN';
eval(paramfile);                % load parameters to script workspace
tv = ts:dt:tf;                  % create time vector

% set exp vs sim
expFlag = 0;
switch massFlag
    case 'sim'
        % ics = [tta, ttad, r1, r2, r3, r4, r1d, r2d, r3d, r4d]
        % initialz = [ics(1:2)*pi/180, ics(3:6), ics(3:6)*0];

        % load exp data if saved
        if exist('expname') == 2
            s1 = load(expname);
            tme = s1.tme;
            acttta = s1.acttta;
            actttad = s1.actttad;
            initialz = [acttta(1)*pi/180, actttad(1)*pi/180, ics(3:6)];
        else
            tme = tv;
            acttta = NaN*tme;
            actttad = acttta;
            initialz = [ics(1:2)*pi/180, ics(3:6)];
        end
        exp2_fca_40 = NaN;
        
    case 'exp'
        expFlag = 1;
        [exp2_fca_40, tta, ttad] = MakeMatrix(expfile, sn);
        [~, indx] = min(abs(exp2_fca_40(:, 1) - ts));   % get start time ics
        tme = exp2_fca_40(indx:end, 1);
        acttta = RelToAbs(tta(indx:end));              % deg
        actttad = ttad(indx:end);
        actttad(2:end) = (acttta(2:end) - acttta(1:end - 1))./(tme(2:end, 1) - tme(1:end - 1, 1));
        initialz = [acttta(1), actttad(1)]*pi/180;
        tf = min([exp2_fca_40(end, 1), tf]);
        
%     case 'sp'
%         expFlag = 1;
%         
%         % load exp data if saved
%         tme = tv;
%         acttta = NaN*tme;
%         actttad = acttta;
%         initialz = [ics(1:2)*pi/180, ics(3:6)];
%         exp2_fca_40 = NaN;
        
        
    otherwise
        error('massFlag argument not recognized.');
       
end 

% load comparison experiment if needed
simcFlag = 0;
if exist(expCname, 'file') == 2
    s2 = load(expCname);
    simCdata = [s2.t, s2.x(:, 1:2)*180/pi, s2.x(:, 3:end)];
    simcFlag = 1;
    ttlstr = ['File: ', expfile, ', Cone Angle: ', num2str(ca*2), 'deg'];
end 
    
    
% run the simulation
outflag = 0;
opts = odeset('MaxStep', 1e-3);
datetime('now');
tic
switch use_ode
    case 'ode45'
        [t, x] = ode45(@(tt, xx)odefunct(tt, xx, exp2_fca_40, ...
            paramfile, outflag), tv, initialz, opts);
    case 'ode23'
        [t, x] = ode23(@(tt, xx)odefunct(tt, xx, exp2_fca_40, ...
            paramfile, outflag), tv, initialz, opts);
    case 'ode5'
        tv = ts:dt:tf;
        % keyboard
        x = ode5(@(tt, xx)odefunct(tt, xx, exp2_fca_40, ...
            paramfile, outflag), tv, initialz);
        t = tv;
    case 'ode5_Controls'
        tv = ts:dt:tf;
        x = ode5_Controls(@(tt, xx)odefunct(tt, xx, exp2_fca_40, ...
            paramfile, outflag), tv, initialz, 'LB', ...
            [-Inf, -Inf, LL, -UL, LL, -UL]', 'UB', [Inf, Inf, UL, -LL, UL, -LL]');
        t = tv;
    otherwise
        error('Unknown case of use_ode.');
end
toc

% re-create the friction and normal force from the simulation
Ff = NaN(length(t), 1);
N = Ff;
ttadd = Ff;
Crr = Ff;
outflag = 1;
pos = NaN(length(t), 4);
vel = pos;
acl = pos;
wrk = zeros(length(t), 2);
ma = wrk;
pwrs = wrk;

for j1 = 1:length(t)
    % dxdt = odefunc_revA(t(j1), x(j1, :), exp2_fca_40, paramfile, outflag);
    dxdt = odefunct(t(j1), x(j1, :), exp2_fca_40, paramfile, outflag);
    
    Ff(j1) = dxdt.Ff;
    N(j1) = dxdt.N;
    ttadd(j1) = dxdt.ttadd;
    Crr(j1) = dxdt.Crr;
    
    pos(j1, :) = dxdt.pos;
    vel(j1, :) = dxdt.vel;
    acl(j1, :) = dxdt.acl;
    
    % work stuff
    ma(j1, :) = dxdt.ma;

end

% save('tempmat.mat');
save(savename);

% % make plot to compare
% figure('Color', 'w');
% hold on
% % plot(exp2_fca_40(:, 1), acttta, '.');
% plot(tme, acttta, '.');
% plot(t, x(:, 1)*180/pi);
% xlabel('Time (s)');
% ylabel('Angle (deg)');
% grid on
% legend({'Data', 'Model'});
% 
% figure('Color', 'w');
% hold on
% % plot(exp2_fca_40(:, 1), actttad, '.');
% plot(tme, actttad, '.');
% plot(t, x(:, 2)*180/pi);
% xlabel('Time (s)');
% ylabel('Angle rate (deg/s)');
% grid on
% legend({'Data', 'Model'});

% figure('Color', 'w');
% hold on
% plot(t, Ff);
% xlabel('Time (s)');
% ylabel('Friction force (N)');
% grid on
% 
% figure('Color', 'w');
% hold on
% plot(t, N);
% xlabel('Time (s)');
% ylabel('Normal force (N)');
% grid on
% 
% figure('Color', 'w');
% hold on
% plot(t, ttadd*180/pi);
% xlabel('Time (s)');
% ylabel('Angular acceleration (deg/s/s)');
% grid on
% 
% figure('Color', 'w');
% hold on
% plot(t, Crr);
% xlabel('Time (s)');
% ylabel('Crr');
% grid on

figure('Color', 'w');
hold on
plot(t, pos(:, 1));
plot(t, pos(:, 2));
plot(t, pos(:, 3));
plot(t, pos(:, 4));
xlabel('Time (s)');
ylabel('Mass pos (m)');
grid on
legend({'1', '2', '3', '4'});
% xlim([0, 60]);
saveas(gcf, [savename(1:end - 4), '_mass.fig']);
saveas(gcf, [savename(1:end - 4), '_mass.jpg']);
movefile([savename(1:end - 4), '_mass.fig'], bindir);
movefile([savename(1:end - 4), '_mass.jpg'], bindir);



figure('Color', 'w');
hold on
plot(t, vel(:, 1));
plot(t, vel(:, 2));
plot(t, vel(:, 3));
plot(t, vel(:, 4));
xlabel('Time (s)');
% xlim([0, 60]);
ylabel('Mass vel (m/s)');
grid on
legend({'1', '2', '3', '4'});
% 
% figure('Color', 'w');
% hold on
% plot(t, acl(:, 1));
% plot(t, acl(:, 2));
% plot(t, acl(:, 3));
% plot(t, acl(:, 4));
% xlabel('Time (s)');
% ylabel('Mass acl (m/s/s)');
% grid on
% legend({'1', '2', '3', '4'});

% keyboard
% eval('MakeMovie');

% % make plot to compare
% figure('Color', 'w');
% set(gcf, 'units', 'normalized');
% set(gcf, 'position', [0.0508    0.3634    0.7145    0.5104]);
cntr = 1;

%%
figure('Color', 'w');
set(gcf, 'units', 'inches');
set(gcf, 'position', [0, 0, 3.8, 4.0]);                 % [xpos, ypos, width, height] ON SCREEN
set(gcf, 'papersize', [3.8, 4.0]);                      % set pdf paper size
set(gcf, 'paperposition', [0, 0, 3.8, 4.0]);    % position ON PAPER
fs_legend = 10;
fs_labels = 10;
%%
subplot(2, 1, 1)
hold on
if expFlag == 1
    plot(tme, acttta, '.');
    lgnd1{cntr} = 'Exp. Data';
    cntr = cntr + 1;
end
plot(t, x(:, 1)*180/pi);
xlabel('Time (s)');
ylabel('Angle (deg)');
grid on
% set(gca, 'xtick', 0:20:400)
% set(gca, 'ytick', 0:20:120)

lgnd1{cntr} = 'Frict sim';
cntr = cntr + 1;
if simcFlag == 1
    plot(simCdata(:, 1), simCdata(:, 2), '-');
    title(ttlstr);
    lgnd1{cntr} = 'c*ttad sim';
end
% legend({'Exp. Data', 'Frict. sim', 'c*ttad sim'}, 'location', 'northwest');
legend(lgnd1, 'location', 'northwest');
xlim([0 400])
% xlim([0, 60]);
box on

subplot(2, 1, 2)
cntr = 1;
if expFlag == 1
    plot(tme, actttad, '.');
end
hold on
plot(t, x(:, 2)*180/pi);
hold on
temp_y = 0;
for tmp = 1:length(t)
    if t(tmp)>=time_of_braking
        temp_y(tmp) = 0;
    else
        temp_y(tmp) = sp;
    end
end

% plot(t,A*sin(2*pi*t/T))
plot(t,temp_y,'r')
legend ('Frict sim','Setpoint')
xlabel('Time (s)');
ylabel('Angle rate (deg/s)');
grid on
% ylim([0, 100]);
%  set(gca, 'xtick', 0:20:400)
 set(gca, 'ytick', 0:20:120)
xlim([0 400])
% xlim([0, 60]);
ylim([-10 120])
box on
if simcFlag == 1
    plot(simCdata(:, 1), simCdata(:, 3), '-');
end
% legend({'Data', 'Model'});

%%
saveas(gcf, [savename(1:end - 4), '_plot.fig']);
saveas(gcf, [savename(1:end - 4), '_plot.jpg']);
movefile([savename(1:end - 4), '_plot.fig'], bindir);
movefile([savename(1:end - 4), '_plot.jpg'], bindir);


% make error plots (again)
if simcFlag == 1
    figure('Color', 'w');
    set(gcf, 'units', 'normalized');
    set(gcf, 'position', [0.0508    0.3634    0.7145    0.5104]);
    subplot(2, 1, 1)
    hold on
    TV = linspace(0, tv(end), 201);
    E1 = interp1(tme, acttta, TV, 'method', 'extrap');
    S1 = interp1(t, x(:, 1)*180/pi, TV, 'method', 'extrap');
    S2 = interp1(simCdata(:, 1), simCdata(:, 2), TV, 'method', 'extrap');
    plot(TV, E1 - S1);
    plot(TV, E1 - S2);
    title(ttlstr);
    xlabel('Time (s)');
    ylabel('Angle Error (deg)');
    grid on
    set(gca, 'xtick', 0:20:100);
    ylim([-200, 200]);
    set(gca, 'xtick', -200:25:200);
    % xlim([0, 60]);
    

    subplot(2, 1, 2)
    hold on
    TV = linspace(0, tv(end), 201);
    E1 = interp1(tme, actttad, TV, 'method', 'extrap');
    S1 = interp1(t, x(:, 2)*180/pi, TV, 'method', 'extrap');
    S2 = interp1(simCdata(:, 1), simCdata(:, 3), TV, 'method', 'extrap');
    plot(TV, E1 - S1);
    plot(TV, E1 - S2);
    xlabel('Time (s)');
    ylabel('Angle Rate Error (deg/s)');
    grid on

    set(gca, 'xtick', 0:20:100)
    ylim([-100, 100]);
    % xlim([0, 60]);
    set(gca, 'xtick', -200:25:200);
    legend({'Exp - Frict. sim', 'Exp - c*ttad sim', 'abs(Exp - Frict. sim)', ...
        'abs(Exp - c*ttad sim)'}, 'location', 'southeast');
    
end
saveas(gcf, [savename(1:end - 4), '_plot.fig']);
saveas(gcf, [savename(1:end - 4), '_error.jpg']);
movefile([savename(1:end - 4), '_plot.fig'], bindir);
movefile([savename(1:end - 4), '_error.jpg'], bindir);

movefile(savename, bindir);