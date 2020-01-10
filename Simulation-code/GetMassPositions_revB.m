function [r1, r2, r3, r4, r1d, r2d, r3d, r4d, r1dd, r2dd, r3dd, r4dd] = ...
    GetMassPositions_revB(x, LL, UL, mv, t, sp, kP_vel, m, mT, A, T, f_variable_sp, f_braking_sim, time_of_braking)

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
%     % -----------------------------------------------------------------
%     % Cone Angle Code for set points - commented out in revB
%     % -----------------------------------------------------------------
%     
%     % schedule
%     % jB is up, kB is right, iB is clockwise
%     % m1 is on +VE jB, points up
%     % m2 is on -VE jB, points down
%   
%   
%     % calculate Set Point for masses
%     if (360 - ca) <= ttaB    % cone 1
%         % mass 3, 4 stay put
%         % mass 1, 2 go up
%         % forward set points
%         x1SP = UL;
%         x2SP = -LL;
%         y3SP = y3;
%         y4SP = y4;
%         % reverse set points
%         x1sp = LL;
%         x2sp = -UL;
%         y3sp = y3;
%         y4sp = y4;
%         
%     elseif ttaB <= (0 + ca)   % cone 1
%         % mass 3, 4 stay put
%         % mass 1, 2 go up
%         % forward set points
%         x1SP = UL;
%         x2SP = -LL;
%         y3SP = y3;
%         y4SP = y4;
%         % reverse set points
%         x1sp = LL;
%         x2sp = -UL;
%         y3sp = y3;
%         y4sp = y4;
%         
%     elseif (90 - ca) <= ttaB && ttaB <= (90 + ca)  % cone 2
%         % forward set points
%         x1SP = x1;
%         x2SP = x2;
%         y3SP = LL;
%         y4SP = -UL;
%         % reverse set points
%         x1sp = x1;
%         x2sp = x2;
%         y3sp = UL;
%         y4sp = -LL;
%         
%     elseif (180 - ca) <= ttaB && ttaB <= (180 + ca)   % cone 3
%         % forward set points
%         x1SP = LL;
%         x2SP = -UL;
%         y3SP = y3;
%         y4SP = y4;
%         % reverse set points
%         x1sp = UL;
%         x2sp = -LL;
%         y3sp = y3;
%         y4sp = y4;
%         
%     elseif (270 - ca) <= ttaB && ttaB <= (270 + ca)   % cone 4
%         % forward set points
%         x1SP = x1;
%         x2SP = x2;
%         y3SP = UL;
%         y4SP = -LL;       
%         % reverse set points
%         x1sp = x1;
%         x2sp = x2;
%         y3sp = LL;
%         y4sp = -UL;
%         
%     else
%         % forward set points
%         x1SP = x1;
%         x2SP = x2;
%         y3SP = y3;
%         y4SP = y4;
%         % reverse set points
%         x1sp = x1SP;
%         x2sp = x2SP;
%         y3sp = y3SP;
%         y4sp = y4SP;
%         
%     end
%     
% %     % correct for velocity setpoint - send to middle position
% %     if isnan(sp) ~= 1
% %         if abs(x(2)*180/pi) > sp
% %             x1SP = (UL + LL)/2;
% %             x2SP = -(UL + LL)/2;
% %             y3SP = (UL + LL)/2;
% %             y4SP = -(UL + LL)/2;
% %         end
% %     end
% 
%     % correct for velocity setpoint - send to other end
%     if isnan(sp) ~= 1
%         if abs(x(2)*180/pi) > sp
%             x1SP = x1sp;
%             x2SP = x2sp;
%             y3SP = y3sp;
%             y4SP = y4sp;
%         end
%     end
    
    
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
    offang = 90;
    yCM = cosd(offang)*maxa;              % maximum yCM value for a rover
    zCM = sind(offang)*maxa;
    D = UL + LL;  
    y3SP = mT.*(zCM.*cosd(theta) - yCM.*sind(theta))./(2*m) + D./2;
    x1SP = mT.*(yCM.*cosd(theta) + zCM.*sind(theta))./(2*m) + D./2;
    x2SP = x1 - D;
    y4SP = y3 - D;
    
    % (-(mT*ttad(i1)*yCM*sin(ttav))./(2*m))
    
    % -----------------------------------------------------------------
    % low level control and mass velocity restrictions for masses
    % NOTE: This is the same for both cone angle and kinematic schemes
    % -----------------------------------------------------------------

%     % velocity
    kP = 20;    % pick something large to make sure mass goes where needed
    x1d = (x1SP - x1)*kP*mv;
    x2d = (x2SP - x2)*kP*mv;
    y3d = (y3SP - y3)*kP*mv;
    y4d = (y4SP - y4)*kP*mv;

    % velocity
    % t
    x1d = min(abs([x1d, mv]))*sign(x1d);
    x2d = min(abs([x2d, mv]))*sign(x2d);
    y3d = min(abs([y3d, mv]))*sign(y3d);
    y4d = min(abs([y4d, mv]))*sign(y4d);
%     % keyboard
    
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
%     r1 = temp1(3);
%     r2 = temp1(4);
%     r3 = temp1(1);
%     r4 = temp1(2);  
%     r1d = temp2(3);
%     r2d = temp2(4);
%     r3d = temp2(1);
%     r4d = temp2(2); 
    r1dd = 0;       % m/s/s
    r2dd = 0;      % m/s/s
    r3dd = 0;      % m/s/s
    r4dd = 0;      % m/s/s

end