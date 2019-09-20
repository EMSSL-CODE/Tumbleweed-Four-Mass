function dxdt = odefunc4M_Rev_G(t, x, exp2_fca_40, paramfile, outflag)

dxdt = zeros(6,1);
eval(paramfile); 
% t

% find the mass velocity values - using Paurav method
 % exp2_fca_40 is the .mat file created from the CSV file import.
[val,idx] = min(abs(exp2_fca_40(:,2)-t));   % finding index of time...
                                            % instance(from the experimental data)...
                                            % closest to the time instance 't' in ode 

% old paurav method + syntax
% x(3) = exp2_fca_40(idx,6)/100;  % experimental value of mass position 1 of index (idx) assigned to x(3) 
% x(4) = exp2_fca_40(idx,8)/100;  % experimental value of mass position 2 of index (idx) assigned to x(4)
% x(5) = exp2_fca_40(idx,10)/100; % experimental value of mass position 3 of index (idx) assigned to x(5)
% x(6) = exp2_fca_40(idx,12)/100; % experimental value of mass position 4 of index (idx) assigned to x(6)
% 
% dxdt(3)=(exp2_fca_40(idx+1,6)-exp2_fca_40(idx,6))/(100*(exp2_fca_40(idx+1,2)-exp2_fca_40(idx,2)));
% dxdt(4)=(exp2_fca_40(idx+1,8)-exp2_fca_40(idx,8))/(100*(exp2_fca_40(idx+1,2)-exp2_fca_40(idx,2)));
% dxdt(5)=(exp2_fca_40(idx+1,10)-exp2_fca_40(idx,10))/(100*(exp2_fca_40(idx+1,2)-exp2_fca_40(idx,2)));
% dxdt(6)=(exp2_fca_40(idx+1,12)-exp2_fca_40(idx,12))/(100*(exp2_fca_40(idx+1,2)-exp2_fca_40(idx,2)));

% old method, new index for new files
% exp2_fca_40 = [time, x1, x2, ... , x3dd, x4dd]
x(3) = exp2_fca_40(idx,2);  % experimental value of mass position 1 of index (idx) assigned to x(3) 
x(4) = exp2_fca_40(idx,3);  % experimental value of mass position 2 of index (idx) assigned to x(4)
x(5) = exp2_fca_40(idx,4); % experimental value of mass position 3 of index (idx) assigned to x(5)
x(6) = exp2_fca_40(idx,5); % experimental value of mass position 4 of index (idx) assigned to x(6)
dxdt(3)=(exp2_fca_40(idx+1,2)-exp2_fca_40(idx,2))/((exp2_fca_40(idx+1,1)-exp2_fca_40(idx,1)));
dxdt(4)=(exp2_fca_40(idx+1,3)-exp2_fca_40(idx,3))/((exp2_fca_40(idx+1,1)-exp2_fca_40(idx,1)));
dxdt(5)=(exp2_fca_40(idx+1,4)-exp2_fca_40(idx,4))/((exp2_fca_40(idx+1,1)-exp2_fca_40(idx,1)));
dxdt(6)=(exp2_fca_40(idx+1,5)-exp2_fca_40(idx,5))/((exp2_fca_40(idx+1,1)-exp2_fca_40(idx,1)));


% % find the mass velocity values - using Paurav method
%  % exp2_fca_40 is the .mat file created from the CSV file import.
% [val,idx] = min(abs(exp2_fca_40(:,2)-t));   % finding index of time...
%                                             % instance(from the experimental data)...
%                                             % closest to the time instance 't' in ode 
% 
% x(3) = exp2_fca_40(idx,6)/100;  % experimental value of mass position 1 of index (idx) assigned to x(3) 
% x(4) = exp2_fca_40(idx,8)/100;  % experimental value of mass position 2 of index (idx) assigned to x(4)
% x(5) = exp2_fca_40(idx,10)/100; % experimental value of mass position 3 of index (idx) assigned to x(5)
% x(6) = exp2_fca_40(idx,12)/100; % experimental value of mass position 4 of index (idx) assigned to x(6)
% dxdt(3) = exp2_fca_40(idx,14);
% dxdt(4) = exp2_fca_40(idx,15);
% dxdt(5) = exp2_fca_40(idx,16);
% dxdt(6) = exp2_fca_40(idx,17);

% % interpolation method
% % 2 = time, 6 = m1, 8 = m2, 10 = m3, 12 = m4
% x(3) = interp1(exp2_fca_40(:, 2), exp2_fca_40(:, 6), t)/100;
% x(4) = interp1(exp2_fca_40(:, 2), exp2_fca_40(:, 8), t)/100;
% x(5) = interp1(exp2_fca_40(:, 2), exp2_fca_40(:, 10), t)/100;
% x(6) = interp1(exp2_fca_40(:, 2), exp2_fca_40(:, 12), t)/100;
% dxdt(3) = interp1(exp2_fca_40(:, 2), exp2_fca_40(:, 14), t);
% dxdt(4) = interp1(exp2_fca_40(:, 2), exp2_fca_40(:, 15), t);
% dxdt(5) = interp1(exp2_fca_40(:, 2), exp2_fca_40(:, 16), t);
% dxdt(6) = interp1(exp2_fca_40(:, 2), exp2_fca_40(:, 17), t);

% % m = 0.3;
% m = 0.3;     %kg
% m1 = m;    %kg
% m2 = m;    %kg
% m3 = m;    %kg
% m4 = m;    %kg
% g = 9.8;     %ms^-2
% Crr0 = 0.000;
% mu = 0;    
% c = 0.0935; % average from roll tests

Ixx =  I_B_B;
M_ch = mCH;



% %% Equations from torque balance
% 
% %     dxdt(1)=-x(2);
% %     dxdt(2)=c*dxdt(1)-(x(2)*(2*m*x(3)*dxdt(3)+2*m*x(4)*dxdt(4)+2*m*x(5)*dxdt(5)+2*m*x(6)*dxdt(6))...
% %         -x(3)*m*(g)*cos(x(1))+x(4)*m*(g)*cos(x(1))...
% %         +x(5)*m*(g)*sin(x(1))-x(6)*m*(g)*sin(x(1)))/...
% %       (m*x(3)^2+m*x(4)^2+m*x(5)^2+m*x(6)^2+Ixx);
% % %   
% 
% % old paurav equation
%      dxdt(1) = x(2);
%      dxdt(2) =-c*dxdt(1) -(m*g*(x(3)*cos(x(1))-x(4)*cos(x(1))-x(5)*sin(x(1))...
%                +x(6)*sin(x(1)))+2*m*x(2)*(x(3)*dxdt(3)+x(4)*dxdt(4)...
%                +x(5)*dxdt(5)+x(6)*dxdt(6))- R*g*mu*(4*m+M_ch))...
%                /(m*(x(3)^2 + x(4)^2 + x(5)^2 + x(6)^2)...
%                + m*R*(-x(3)*sin(x(1)) + x(4)*sin(x(1))...
%                - x(5)*cos(x(1)) + x(6)*cos(x(1))) + Ixx);
%            
% new paurav equation
% Crr = Crr0*(0.5*erf((2*(x(2)/55) - 1)*3) + 0.5);
Crr = Crr0;
dxdt(1) = x(2);
dxdt(2) = -(m*g*(x(3)*cos(x(1))-x(4)*cos(x(1))-x(5)*sin(x(1))...
       +x(6)*sin(x(1)))+2*m*x(2)*(x(3)*dxdt(3)+x(4)*dxdt(4)...
       +x(5)*dxdt(5)+x(6)*dxdt(6))- R*g*mu*(4*m+M_ch) ...
       + c*dxdt(1) + Crr*R*g*(4*m + M_ch)*sign(x(2)))...
       /(m*(x(3)^2 + x(4)^2 + x(5)^2 + x(6)^2)...
       + m*R*(-x(3)*sin(x(1)) + x(4)*sin(x(1))...
       - x(5)*cos(x(1)) + x(6)*cos(x(1))) + Ixx);

% % rederive 1/17/19
% tta = x(1);     % rad
% ttad = x(2);    % rad/s
% x1 = x(3);      % m
% x2 = x(4);      % m
% y3 = x(5);      % m
% y4 = x(6);      % m
% mCH = M_ch;     % kg
% I_B_B = Ixx;    % kg-m2
% x1d = dxdt(3);  % m/s
% x2d = dxdt(4);  % m/s
% y3d = dxdt(5);  % m/s
% y4d = dxdt(6);  % m/s
% 
% dxdt(1) = ttad;
% dxdt(2) = -(c*ttad + 2*m1*ttad*x1*x1d + 2*m2*ttad*x2*x2d + 2*m3*ttad*y3*y3d + ...
%     2*m4*ttad*y4*y4d - 2*R*m1*ttad^2*x1 + 2*R*m2*ttad^2*x2 + g*m1*x1*cos(tta) - ...
%     g*m2*x2*cos(tta) - g*m3*y3*sin(tta) + g*m4*y4*sin(tta) + Crr*R*g*m1*sign(ttad) + ...
%     Crr*R*g*m2*sign(ttad) + Crr*R*g*m3*sign(ttad) + Crr*R*g*m4*sign(ttad) + ...
%     Crr*R*g*mCH*sign(ttad) - R*m3*tta*ttad^2*y3 + R*m4*tta*ttad^2*y4)/(m1*x1^2 - ...
%     R*m1*tta*x1 + m2*x2^2 + R*m2*tta*x2 + m3*y3^2 + R*m3*y3 + m4*y4^2 - R*m4*y4 + I_B_B);
 
% if norm(dxdt) > 10
%     t
%     x
%     dxdt
%     keyboard
% end

% t
% x
% dxdt
% keyboard

end
