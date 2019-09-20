% simulate downhill testing
%
% revA = CDY @ 2019-70-11

clc
close all
clear
SetDefaults

% parameters for the simulation
oldfile = 'Batch_file';    % batch mode base run file
logfile = 'logfile.txt';    % log of all runs

% variables to change
angvel = [70, 90];
cas = [10, 20, 30, 40];      % full cone angle
massm = [0.3, 0.6, 0.9];
rovern = [1, 3, 5];
massv = [0.2, 0.6, 1];

% rover parameters
LLs = [0.20, 0.25, 0.30];
ULs = [0.3621, 0.55, 0.74];
IBBs = [1.6607, 5.4495, 14.1072];
mCHs = [14.809, 21.027, 29.385];
Rs = [0.50, 0.75, 1.00];



% leave everything below this alone! -CDY
% -----------------------------------------------------------------------
fLOG = fopen(logfile, 'a+');
fprintf(fLOG, 'Paramfile, roverNumber, MassV, MassM, Angvel, HCA\n');
fclose(fLOG);
                    
for a1 = 1:length(angvel)   % for all angular velocities
    for b1 = 1:length(cas)   % for all cone angles
        
        % run the 27 cases using ode45
        basename = sprintf('sp_%d_ca_%d', angvel(a1), cas(b1)/2);
        bindir = basename;
        
        % check bin
        if exist(bindir, 'dir') ~= 7
            mkdir(bindir);
        end
        
        cntr = 0;
        for c1 = 1:length(massv)
            for d1 = 1:length(rovern)
                for e1 = 1:length(massm)
                    cntr = cntr + 1;
                    paramfile = [basename, sprintf('_Run%d', cntr)];
                    fprintf('Running: %s\n', paramfile);
                                      
                    % write run file
                    fOLD = fopen([oldfile, '.m'], 'r');
                    fNEW = fopen([paramfile, '.m'], 'w');
                    oldline = fgetl(fOLD);      % get header
                    fprintf(fNEW, oldline);     % print header
                    for i1 = 2:11               % skip lines
                        oldline = fgetl(fOLD);
                    end                  
                    % rover parameters
                    fprintf(fNEW, '%% Rover number: %d\n', rovern(d1));
                    fprintf(fNEW, 'LL = %0.4f;\n', LLs(d1));
                    fprintf(fNEW, 'UL = %0.4f;\n', ULs(d1));
                    fprintf(fNEW, 'I_B_B = %0.4f;\n', IBBs(d1));
                    fprintf(fNEW, 'mCH = %0.4f;\n', mCHs(d1));
                    fprintf(fNEW, 'R = %0.4f;\n', Rs(d1));
                    % mass mass and velocity
                    fprintf(fNEW, 'mv = %0.4f;\n', massv(c1));
                    fprintf(fNEW, 'm = %0.4f;\n', massm(e1));
                    fprintf(fNEW, 'sp = %0.4f;\n', angvel(a1));
                    fprintf(fNEW, 'ca = %0.4f;\n', cas(b1)/2);
                    fprintf(fNEW, 'savename = ''Run%d.mat'';', cntr);
                    for i1 = 12:28               
                        oldline = fgetl(fOLD);
                        fprintf(fNEW, '%s\n', oldline);     % print old line
                    end  
                    fclose(fOLD);
                    fclose(fNEW);
                    
                    % write log file
                    fLOG = fopen(logfile, 'a+');
                    fprintf(fLOG, '%s,%d,%0.4f,%0.4f,%0.4f,%0.4f\n', paramfile, rovern(d1), ...
                        massv(c1), massm(e1), angvel(a1), cas(b1)/2);
                    fclose(fLOG);
                   
                    
                    % do regular stuffs
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

                        otherwise
                            error('massFlag argument not recognized.');

                    end 

                    % load comparison experiment if needed
                    simcFlag = 0;
                    if exist(expCname, 'file') == 2
                        s2 = load(expCname);
                        simCdata = [s2.t, s2.x(:, 1:2)*180/pi, s2.x(:, 3:end)];
                        simcFlag = 1;
                        % ttlstr = ['File: ', expfile, ', Cone Angle: ', num2str(ca*2), 'deg'];
                    end 


                    % run the simulation
                    outflag = 0;
                    opts = odeset('MaxStep', 1e-3);
                    run_start = datetime('now');
                    user_name = getenv('username');
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
                        otherwise
                            error('Unknown case of use_ode.');
                    end
                    comp_time = toc;

                    % re-create the friction and normal force from the simulation
                    Ff = NaN(length(t), 1);
                    N = Ff;
                    ttadd = Ff;
                    Crr = Ff;
                    outflag = 1;
                    pos = NaN(length(t), 4);
                    vel = pos;
                    acl = pos;
                    for j1 = 1:length(t)
                        dxdt = odefunct(t(j1), x(j1, :), exp2_fca_40, paramfile, outflag);

                        Ff(j1) = dxdt.Ff;
                        N(j1) = dxdt.N;
                        ttadd(j1) = dxdt.ttadd;
                        Crr(j1) = dxdt.Crr;

                        pos(j1, :) = dxdt.pos;
                        vel(j1, :) = dxdt.vel;
                        acl(j1, :) = dxdt.acl;
                    end

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
                    saveas(gcf, [paramfile, '_mass.fig']);
                    saveas(gcf, [paramfile, '_mass.jpg']);
                    movefile([paramfile, '_mass.fig'], bindir);
                    movefile([paramfile, '_mass.jpg'], bindir);

                    figure('Color', 'w');
                    hold on
                    plot(t, x(:, 1)*180/pi, 'DisplayName', 'Angle');
                    xlabel('Time [s]');
                    ylabel('Angle [deg]');
                    grid on
                    saveas(gcf, [paramfile, '_angle.fig']);
                    saveas(gcf, [paramfile, '_angle.jpg']);
                    movefile([paramfile, '_angle.fig'], bindir);
                    movefile([paramfile, '_angle.jpg'], bindir);
                    
                    figure('Color', 'w');
                    hold on
                    plot(t, x(:, 2)*180/pi, 'DisplayName', 'AngleDot');
                    xlabel('Time [s]');
                    ylabel('Angular rate [deg/s]');
                    grid on
                    saveas(gcf, [paramfile, '_angledot.fig']);
                    saveas(gcf, [paramfile, '_angledot.jpg']);
                    movefile([paramfile, '_angledot.fig'], bindir);
                    movefile([paramfile, '_angledot.jpg'], bindir);

                    % save('tempmat.mat');
                    save(savename);
                    movefile(savename, bindir);
                    movefile([paramfile, '.m'], bindir);
                    
                    close('all');
                    
                end
            end
        end
    end
end