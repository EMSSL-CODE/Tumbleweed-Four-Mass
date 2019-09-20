% script to look at mass motion from controller

clc
close all
clear

% rolling conditions
paramfile = 'sim1';
eval(paramfile);
tv = ts:dt:tf*3;                  % create time vector
x = ics;
pos = NaN(length(tv), 4);
vel = pos;
acl = pos;
tta = NaN(length(tv), 1);
ttad = 30;   % deg/s
x(2) = ttad;
for i1 = 1:length(tv)
    x(1) = x(1)*pi/180;
%     [x1, x2, y3, y4, x1d, x2d, y3d, y4d, x1dd, x2dd, y3dd, y4dd] = ...
%         GetMassPositions(x, ca, LL, UL, mv);
    [x1, x2, y3, y4, x1d, x2d, y3d, y4d, x1dd, x2dd, y3dd, y4dd] = ...
        GetMassPositions_revA(x, ca, LL, UL, mv);
    pos(i1, :) = [x1, x2, y3, y4];
    vel(i1, :) = [x1d, x2d, y3d, y4d];
    acl(i1, :) = [x1dd, x2dd, y3dd, y4dd];
    x(1) = x(1)*180/pi;
    tta(i1) = x(1);
    
    % "integrate" and go again
    x(1) = tta(i1) + dt*ttad;
    x(3:6) = dt*vel(i1, :) + pos(i1, :);
    x(7:10) = dt*acl(i1, :) + vel(i1, :);
end

figure('Color', 'w');
hold on
plot(tv, tta);
xlabel('Time');
ylabel('Angle');

figure('Color', 'w');
hold on
plot(tv, pos(:, 1));
plot(tv, pos(:, 2));
plot(tv, pos(:, 3));
plot(tv, pos(:, 4));
xlabel('Time');
ylabel('Positions');  