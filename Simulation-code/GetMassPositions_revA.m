function [r1, r2, r3, r4, r1d, r2d, r3d, r4d, r1dd, r2dd, r3dd, r4dd] = ...
    GetMassPositions_revA(x, ca, LL, UL, mv, t, sp)

% Function to get mass positions, velocities, and accelerations.
% CDY, 5/12/19
    ttaB = mod(x(1), 2*pi)*180/pi;      % on the interval [0, 360]
    x1 = x(3);         % m
    x2 = x(4);         % m
    y3 = x(5);         % m
    y4 = x(6);         % m
    x1d = 0;         % m/s
    x2d = 0;         % m/s
    y3d = 0;         % m/s
    y4d = 0;         % m/s
    % kP = 3;
    kP = 20;
    
    % calculate Set Point for masses
    if (360 - ca) <= ttaB    % cone 1
        % mass 3, 4 stay put
        % mass 1, 2 go up
%         x1d = mv;
%         x2d = mv;
%         y3d = 0;
%         y4d = 0;
        x1SP = UL;
        x2SP = -LL;
        y3SP = y3;
        y4SP = y4;
        
        x1sp = LL;
        x2sp = -UL;
        y3sp = y3;
        y4sp = y4;
        
    elseif ttaB <= (0 + ca)   % cone 1
        % mass 3, 4 stay put
        % mass 1, 2 go up
%         x1d = mv;
%         x2d = mv;
%         y3d = 0;
%         y4d = 0;
        x1SP = UL;
        x2SP = -LL;
        y3SP = y3;
        y4SP = y4;
        
        x1sp = LL;
        x2sp = -UL;
        y3sp = y3;
        y4sp = y4;
        
    elseif (90 - ca) <= ttaB && ttaB <= (90 + ca)  % cone 2
%         x1d = 0;
%         x2d = 0;
%         y3d = -mv;
%         y4d = -mv;
        x1SP = x1;
        x2SP = x2;
        y3SP = LL;
        y4SP = -UL;
        
        x1sp = x1;
        x2sp = x2;
        y3sp = UL;
        y4sp = -LL;
        
    elseif (180 - ca) <= ttaB && ttaB <= (180 + ca)   % cone 3
%         x1d = -mv;
%         x2d = -mv;
%         y3d = 0;
%         y4d = 0;
        x1SP = LL;
        x2SP = -UL;
        y3SP = y3;
        y4SP = y4;
        
        x1sp = UL;
        x2sp = -LL;
        y3sp = y3;
        y4sp = y4;
        
    elseif (270 - ca) <= ttaB && ttaB <= (270 + ca)   % cone 4
%         x1d = 0;
%         x2d = 0;
%         y3d = mv;
%         y4d = mv;
        x1SP = x1;
        x2SP = x2;
        y3SP = UL;
        y4SP = -LL;
        
        x1sp = x1;
        x2sp = x2;
        y3sp = LL;
        y4sp = -UL;
        
    else
%         x1d = 0;        % m/s
%         x2d = 0;        % m/s
%         y3d = 0;        % m/s
%         y4d = 0;        % m/s
        x1SP = x1;
        x2SP = x2;
        y3SP = y3;
        y4SP = y4;
        
        x1sp = x1SP;
        x2sp = x2SP;
        y3sp = y3SP;
        y4sp = y4SP;
        
    end
    
%     % correct for velocity setpoint - send to middle position
%     if isnan(sp) ~= 1
%         if abs(x(2)*180/pi) > sp
%             x1SP = (UL + LL)/2;
%             x2SP = -(UL + LL)/2;
%             y3SP = (UL + LL)/2;
%             y4SP = -(UL + LL)/2;
%         end
%     end

    % correct for velocity setpoint - send to other end
    if isnan(sp) ~= 1
        if abs(x(2)*180/pi) > sp
            x1SP = x1sp;
            x2SP = x2sp;
            y3SP = y3sp;
            y4SP = y4sp;
        end
    end
        
%     
    % velocity
    x1d = (x1SP - x1)*kP*mv;
    x2d = (x2SP - x2)*kP*mv;
    y3d = (y3SP - y3)*kP*mv;
    y4d = (y4SP - y4)*kP*mv;

    % velocity
    x1d = min(abs([x1d, mv]))*sign(x1d);
    x2d = min(abs([x2d, mv]))*sign(x2d);
    y3d = min(abs([y3d, mv]))*sign(y3d);
    y4d = min(abs([y4d, mv]))*sign(y4d);
    
    % verify within the mass bounds
    temp1 = [x1, x2, y3, y4];
    temp2 = [x1d, x2d, y3d, y4d];
%     for i1 = 1:length(temp1)
%         if abs(temp1(i1)) > UL
%             temp1(i1) = sign(temp1(i1))*(UL - 0.001);
%             temp2(i1) = 0;
%         elseif abs(temp1(i1)) < LL
%             temp1(i1) = sign(temp1(i1))*(LL + 0.001);
%             temp2(i1) = 0;
%         end
%     end
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