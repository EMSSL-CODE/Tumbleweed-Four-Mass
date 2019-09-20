% simulate downhill testing
%
% revA = CDY @ 2019-07-11
% revB = CDY @ 2019-07-20 - compare cone angle and kinematics

clc
close all
clear
SetDefaults

% angular velocity sims
bindir = 'Compares';
% paramfile = 'Compare_sp_70_ca_15_A';  % run 1, revB
% paramfile = 'Compare_sp_70_ca_15_C';  % run 1, revC controlled
% paramfile = 'Compare_sp_30_ca_5_A';  % run 2, revA
% paramfile = 'Compare_sp_30_ca_5_B';  % run 2, revB
% paramfile = 'Compare_sp_50_ca_20_A';  % run 3, revA
% paramfile = 'Compare_sp_50_ca_20_B';  % run 3, revB

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
    dxdt = odefunc_revA(t(j1), x(j1, :), exp2_fca_40, paramfile, outflag);
    
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
saveas(gcf, [savename(1:end - 4), '_mass.fig']);
saveas(gcf, [savename(1:end - 4), '_mass.jpg']);
movefile([savename(1:end - 4), '_mass.fig'], bindir);
movefile([savename(1:end - 4), '_mass.jpg'], bindir);



% figure('Color', 'w');
% hold on
% plot(t, vel(:, 1));
% plot(t, vel(:, 2));
% plot(t, vel(:, 3));
% plot(t, vel(:, 4));
% xlabel('Time (s)');
% ylabel('Mass vel (m/s)');
% grid on
% legend({'1', '2', '3', '4'});
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

% make plot to compare
figure('Color', 'w');
set(gcf, 'units', 'normalized');
set(gcf, 'position', [0.0508    0.3634    0.7145    0.5104]);
cntr = 1;
subplot(1, 2, 1)
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
set(gca, 'xtick', 0:20:100)
lgnd1{cntr} = 'Frict sim';
cntr = cntr + 1;
if simcFlag == 1
    plot(simCdata(:, 1), simCdata(:, 2), '-');
    title(ttlstr);
    lgnd1{cntr} = 'c*ttad sim';
end
% legend({'Exp. Data', 'Frict. sim', 'c*ttad sim'}, 'location', 'northwest');
legend(lgnd1, 'location', 'northwest');


subplot(1, 2, 2)
cntr = 1;
if expFlag == 1
    plot(tme, actttad, '.');
end
hold on
plot(t, x(:, 2)*180/pi);
xlabel('Time (s)');
ylabel('Angle rate (deg/s)');
grid on
% ylim([0, 100]);
% set(gca, 'xtick', 0:20:100)
% set(gca, 'ytick', 0:20:100)
if simcFlag == 1
    plot(simCdata(:, 1), simCdata(:, 3), '-');
end
% legend({'Data', 'Model'});
saveas(gcf, [savename(1:end - 4), '_plot.fig']);
saveas(gcf, [savename(1:end - 4), '_plot.jpg']);
movefile([savename(1:end - 4), '_plot.fig'], bindir);
movefile([savename(1:end - 4), '_plot.jpg'], bindir);


% make error plots (again)
if simcFlag == 1
    figure('Color', 'w');
    set(gcf, 'units', 'normalized');
    set(gcf, 'position', [0.0508    0.3634    0.7145    0.5104]);
    subplot(1, 2, 1)
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
    

    subplot(1, 2, 2)
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
    set(gca, 'xtick', -200:25:200);
    legend({'Exp - Frict. sim', 'Exp - c*ttad sim', 'abs(Exp - Frict. sim)', ...
        'abs(Exp - c*ttad sim)'}, 'location', 'southeast');
    
end
saveas(gcf, [savename(1:end - 4), '_plot.fig']);
saveas(gcf, [savename(1:end - 4), '_error.jpg']);
movefile([savename(1:end - 4), '_plot.fig'], bindir);
movefile([savename(1:end - 4), '_error.jpg'], bindir);

movefile(savename, bindir);