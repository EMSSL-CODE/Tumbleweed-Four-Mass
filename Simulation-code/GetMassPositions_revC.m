function [r1, r2, r3, r4, r1d, r2d, r3d, r4d, r1dd, r2dd, r3dd, r4dd] = ...
    GetMassPositions_revC(x, LL, UL, mv, t, sp, kP_vel, m, mT, A, T, ...
    f_variable_sp, f_braking_sim, time_of_braking, offang)

% Function to get mass positions, velocities, and accelerations.
% CDY
%   revA - 5/12/19, cone angle code
%   revB - 7/20/19, kinematic relationship
    ttaB = mod(x(1), 2*pi)*180/pi;      % on the interval [0, 360]
    ttaBd = x(2)*180/pi;
    x1 = x(3);         % m
    x2 = x(4);         % m
    y3 = x(5);         % m
    y4 = x(6);         % m
    x1d = 0;         % m/s
    x2d = 0;         % m/s
    y3d = 0;         % m/s
    y4d = 0;         % m/s
    
    if f_variable_sp == 1
        sp = A*sin(2*pi*t/T);
    end
    
    if f_braking_sim ==1 && t >= time_of_braking
        sp = 0;
    end
    
    % -----------------------------------------------------------------
    % Kinematic constraint code for set points
    % -----------------------------------------------------------------
    
%     % angle controller
%     % t
%     theta = ttaB;
%     thetad = ttaBd;
%     vel_err = (sp - ttaBd);                 % error in angular velocity
%     rtravel = UL - LL;                      % travel of masses 
%     max_ycm = rtravel*(m/mT);              % maximum yCM value for a rover
%     raw_ycm = vel_err*kP_vel;               % error * kP (scaled to mass actuation bounds)
%     yCM = min(abs([max_ycm, raw_ycm]));     % saturation limit of yCM based on rover design
%     yCM = raw_ycm;
%     zCM = 0;                                % set to zero, can be other places too. 
%     D = UL + LL;                            % mass constraints
%     r1 = mT.*(yCM.*cosd(theta) + zCM.*sind(theta))./(2*m) + D./2; 
%     r3 = mT.*(zCM.*cosd(theta) - yCM.*sind(theta))./(2*m) + D./2;
%     r2 = r1 - D;
%     r4 = r3 - D;
%     x1SP = r1;  % rename
%     x2SP = r2;  % rename
%     y3SP = r3;  % rename
%     y4SP = r4;  % rename
%     % keyboard


    % r1 +VE jB, vertical mass
    % r2 -VE jB, vertical mass
    % r3 +VE kB, horizontal mass
    % r4 -VE kB, horizontal mass   
    % do control of angular velocity
    theta = ttaB;
    angvel = ttaBd*pi/180;
    rtravel = UL - LL;                      % travel of masses 
    maxo = rtravel*(m/mT);                  % max position
    err = (sp - angvel*180/pi);
    inpt = (err/100)*kP_vel;      % kP input to system, 100 scales. \
    maxa = min(abs([maxo, inpt]))*sign(err);

    % specify stuffs
    % offang = 90;
    yCM = cosd(offang)*maxa;              % maximum yCM value for a rover
    zCM = sind(offang)*maxa;
    D = UL + LL;  
    % r1 = mT*(yCM*cos(ttac) + zCM*sin(ttac))/(2*m) + D/2
    % r3 = mT*(zCM*cos(ttac) - yCM*sin(ttac))/(2*m) + D/2
    x1SP = mT.*(yCM.*cosd(theta) + zCM.*sind(theta))./(2*m) + D./2;
    y3SP = mT.*(zCM.*cosd(theta) - yCM.*sind(theta))./(2*m) + D./2;
    x2SP = x1 - D;
    y4SP = y3 - D;
            
    % -----------------------------------------------------------------
    % low level control and mass velocity restrictions for masses
    % NOTE: This is the same for both cone angle and kinematic schemes
    % -----------------------------------------------------------------

    % % % revC - kinematic velocity based on SP and "perfect" low level control
    % x1d = (mT*(angvel*zCM*cosd(theta) - angvel*yCM*sind(theta)))/(2*m);
    % y3d = -(mT*(angvel*yCM*cosd(theta) + angvel*zCM*sind(theta)))/(2*m);
    % x2d = x1d;
    % y4d = y3d;
    
    % % velocity
    % % t
    kP = 20;                        % pick something large to make sure mass goes where needed
    x1d = (x1SP - x1)*kP*mv;
    x2d = (x2SP - x2)*kP*mv;
    y3d = (y3SP - y3)*kP*mv;
    y4d = (y4SP - y4)*kP*mv;
    x1d = min(abs([x1d, mv]))*sign(x1d);
    x2d = min(abs([x2d, mv]))*sign(x2d);
    y3d = min(abs([y3d, mv]))*sign(y3d);
    y4d = min(abs([y4d, mv]))*sign(y4d);
    
    % verify within the mass bounds
    temp1 = [x1, x2, y3, y4];
    temp2 = [x1d, x2d, y3d, y4d];
    % keyboard
    r1 = temp1(1);
    r2 = temp1(2);
    r3 = temp1(3);
    r4 = temp1(4);  
    r1d = temp2(1);
    r2d = temp2(2);
    r3d = temp2(3);
    r4d = temp2(4);  
    r1dd = 0;       % m/s/s
    r2dd = 0;      % m/s/s
    r3dd = 0;      % m/s/s
    r4dd = 0;      % m/s/s

end