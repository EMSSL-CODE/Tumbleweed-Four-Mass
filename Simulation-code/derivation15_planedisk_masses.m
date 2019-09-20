function derivation15_planedisk_masses
% derivation of tumbleweed code
% rolling case

clc
close all
clear
disp('Begin derivation...');
tic 

% Problem Formulation
% iO = into page
% jO = altitude
% kO = right
% theta is about kO, +VE results in -VE iO motion

% derive parameters
syms t xBc(t) xB xBd xBdd yBc(t) yB yBd yBdd
syms ttac(t) tta ttad ttadd
syms x1c(t) x1 x1d x1dd x2c(t) x2 x2d x2dd
syms y3c(t) y3 y3d y3dd y4c(t) y4 y4d y4dd
syms m1 m2 m3 m4 mCH
syms g us R I_B_B N const Ff Crr

% rotation matrix
OCB = sym('OCB', [3, 3]);
OCB(1, 1) = 1;
OCB(1, 2) = 0;
OCB(1, 3) = 0;
OCB(2, 1) = 0;
OCB(2, 2) = cos(ttac);
OCB(2, 3) = -sin(ttac);
OCB(3, 1) = 0;
OCB(3, 2) = sin(ttac);
OCB(3, 3) = cos(ttac);
BCO = transpose(OCB);


% positions
% x1 +VE, x2 -VE
r_BO_O = sym('r_BO_O', [3, 1]);
r_BO_O(1) = R*ttac;
r_BO_O(2) = 0;
r_BO_O(3) = 0;
r_PB_O = sym('r_PB_O', [3, 1]);
r_PB_O(1) = 0;
r_PB_O(2) = -R;
r_PB_O(3) = 0;
r_m1B_B = sym('r_m1B_B', [3, 1]);
r_m1B_B(1) = 0;
r_m1B_B(2) = x1c;
r_m1B_B(3) = 0;
r_m2B_B = sym('r_m2B_B', [3, 1]);
r_m2B_B(1) = 0;
r_m2B_B(2) = x2c;
r_m2B_B(3) = 0;
r_m3B_B = sym('r_m3B_B', [3, 1]);
r_m3B_B(1) = 0;
r_m3B_B(2) = 0;
r_m3B_B(3) = y3c;
r_m4B_B = sym('r_m4B_B', [3, 1]);
r_m4B_B(1) = 0;
r_m4B_B(2) = 0;
r_m4B_B(3) = y4c;
r_CMB_B = (m1*r_m1B_B + m2*r_m2B_B + m3*r_m3B_B + m4*r_m4B_B)/(m1 + m2 + m3 + m4 + mCH);
r_CMO_B = BCO*r_BO_O + r_CMB_B;
disp('Position vectors complete');

% angular velocity
w_OB_O = sym('w_OB_B', [3, 1]);
w_OB_O(1) = diff(ttac, t);
w_OB_O(2) = 0;
w_OB_O(3) = 0;
w_OB_B = BCO*w_OB_O;


% velocities
O_v_m1B_B = FirstTransport(r_m1B_B, w_OB_B, t);
O_v_m2B_B = FirstTransport(r_m2B_B, w_OB_B, t);
O_v_m3B_B = FirstTransport(r_m3B_B, w_OB_B, t);
O_v_m4B_B = FirstTransport(r_m4B_B, w_OB_B, t);
O_v_BO_O = diff(r_BO_O, t);
O_v_m1O_B = O_v_m1B_B + BCO*O_v_BO_O;
O_v_m2O_B = O_v_m2B_B + BCO*O_v_BO_O;
O_v_m3O_B = O_v_m3B_B + BCO*O_v_BO_O;
O_v_m4O_B = O_v_m4B_B + BCO*O_v_BO_O;
O_v_CMB_B = FirstTransport(r_CMB_B, w_OB_B, t);
O_v_CMO_B = BCO*O_v_BO_O + O_v_CMB_B;
disp('Velocity vectors complete');

% angular acceleration
a_OB_O = sym('a_OB_B', [3, 1]);
a_OB_O(1) = diff(ttac, t, t);
a_OB_O(2) = 0;
a_OB_O(3) = 0;
a_OB_B = BCO*a_OB_O;

% accelerations
O_a_m1B_B = SecondTransport(r_m1B_B, w_OB_B, t);
O_a_m2B_B = SecondTransport(r_m2B_B, w_OB_B, t);
O_a_m3B_B = SecondTransport(r_m3B_B, w_OB_B, t);
O_a_m4B_B = SecondTransport(r_m4B_B, w_OB_B, t);
O_a_BO_O = diff(r_BO_O, t, t);
O_a_CMB_B = SecondTransport(r_CMB_B, w_OB_B, t);
O_a_CMO_B = BCO*O_a_BO_O + O_a_CMB_B;
disp('Acceleration vectors complete');
% results in equations in X, Y

% angular velocity
% OhOB,B in B frame
O_h_O_B_m1_B = cross(r_m1B_B, m1*O_v_m1O_B);
O_h_O_B_m2_B = cross(r_m2B_B, m2*O_v_m2O_B);
O_h_O_B_m3_B = cross(r_m3B_B, m3*O_v_m3O_B);
O_h_O_B_m4_B = cross(r_m4B_B, m4*O_v_m4O_B);
O_h_O_B_B_B = I_B_B*w_OB_B;
O_h_O_B_total_B = O_h_O_B_B_B + O_h_O_B_m1_B + O_h_O_B_m2_B + ...
     O_h_O_B_m3_B + O_h_O_B_m4_B;
% results in equation in Z

% forces
Fg_O = [0; -(m1 + mCH)*g; 0];
FN_O = [0; N; 0];
% Fr_O = [0; 0; -Crr*abs(N)]; % rolling resistance force, should be correct
Fr_O = [0; 0; -Crr*N]; % rolling resistance force, should be correct
Ff_O = [0; 0; Ff];
Fg_B = BCO*Fg_O;
FN_B = BCO*FN_O;
Fr_B = BCO*Fr_O;
Ff_B = BCO*Ff_O;

% torques
T_f_O = cross(r_PB_O, Ff_O);    % friction torque
T_f_B = BCO*T_f_O;
T_g_B = cross(r_CMB_B, BCO*Fg_O);
disp('Force/Torque vectors complete');

% % constraint equation
% eqnC = xBc - R*ttac - const;                    % x - r*tta = constant
% eqnCd = diff(xBc, t) - R*diff(ttac, t);         % xd - r*ttad = 0
% eqnCdd = diff(xBc, t, t) - R*diff(ttac, t, t);  % xdd = r*ttadd

% oddt OhOB
% Oddt_O_h_O_B_m1_B = cross(O_v_m1B_B, m1*O_v_m1O_B) + cross(r_m1B_B, m1*O_a_m1O_B);
% Oddt_O_h_O_B_m2_B = cross(O_v_m2B_B, m2*O_v_m2O_B) + cross(r_m2B_B, m2*O_a_m2O_B);
% Oddt_O_h_O_B_m3_B = cross(O_v_m3B_B, m3*O_v_m3O_B) + cross(r_m3B_B, m3*O_a_m3O_B);
% Oddt_O_h_O_B_m4_B = cross(O_v_m4B_B, m4*O_v_m4O_B) + cross(r_m4B_B, m4*O_a_m4O_B);
% Oddt_O_h_O_B_m1_B = FirstTransport(O_h_O_B_m1_B, w_OB_B, t);
% Oddt_O_h_O_B_m2_B = FirstTransport(O_h_O_B_m2_B, w_OB_B, t);
% Oddt_O_h_O_B_m3_B = FirstTransport(O_h_O_B_m3_B, w_OB_B, t);
% Oddt_O_h_O_B_m4_B = FirstTransport(O_h_O_B_m4_B, w_OB_B, t);
% Oddt_O_h_O_B_B_B = FirstTransport(O_h_O_B_B_B, w_OB_B, t);
% Oddt_O_h_O_B_total_B = Oddt_O_h_O_B_B_B + Oddt_O_h_O_B_m1_B + Oddt_O_h_O_B_m2_B + ...
%     Oddt_O_h_O_B_m3_B + Oddt_O_h_O_B_m4_B;
Oddt_O_h_O_B_total_B = FirstTransport(O_h_O_B_total_B, w_OB_B, t) + ...
      cross(BCO*O_v_BO_O, (m1 + m2 + m3 + m4 + mCH)*O_v_CMO_B);

% summation of forces
% eqns_F_B = Fg_B + FN_B + Ff_B - (m1 + m2 + m3 + m4 + mCH)*O_a_CMO_B;
eqns_F_B = Fg_B + FN_B + Fr_B + Ff_B - (m1 + m2 + m3 + m4 + mCH)*O_a_CMO_B;

% summation of torques
% SUM_T = Gravity + Friction = oddt ohob 
eqns_T_B = T_f_B + T_g_B - Oddt_O_h_O_B_total_B;

% substitutions 
% eqn1_T_B is nonzero for (3)
% eqn1_F_B is nonzero for (1), (2)
% unknowns: N, ttadd, xBdd, yBdd=0
eqn1_T_B = simplify(subs(eqns_T_B, ...
    [xBc, diff(xBc, t), diff(xBc, t, t), yBc, diff(yBc, t), diff(yBc, t, t), ...
     x1c, diff(x1c, t), diff(x1c, t, t), x2c, diff(x2c, t), diff(x2c, t, t), ...
     y3c, diff(y3c, t), diff(y3c, t, t), y4c, diff(y4c, t), diff(y4c, t, t), ...
     ttac, diff(ttac, t), diff(ttac, t, t)], [xB, xBd, xBdd, yB, 0, 0, ...
     x1, x1d, x1dd, x2, x2d, x2dd, y3, y3d, y3dd, y4, y4d, y4dd, tta, ttad, ttadd]));
eqn1_F_B = simplify(subs(eqns_F_B, ...
    [xBc, diff(xBc, t), diff(xBc, t, t), yBc, diff(yBc, t), diff(yBc, t, t), ...
     x1c, diff(x1c, t), diff(x1c, t, t), x2c, diff(x2c, t), diff(x2c, t, t), ...
     y3c, diff(y3c, t), diff(y3c, t, t), y4c, diff(y4c, t), diff(y4c, t, t), ...
     ttac, diff(ttac, t), diff(ttac, t, t)], [xB, xBd, xBdd, yB, 0, 0, ...
     x1, x1d, x1dd, x2, x2d, x2dd, y3, y3d, y3dd, y4, y4d, y4dd, tta, ttad, ttadd]));
disp('Substitutions complete');

% % convert to matrix
% [A, b] = equationsToMatrix([eqn1_T_B(3), eqn1_F_B(1), eqn1_F_B(2)], [N, Ff, ttadd]);
% eqns2 = A\b;    % eqns for N, Ff, ttadd
% % save to matrix
% N_O = simplify(eqns2(1));
% Ff_O = simplify(eqns2(2));
% ttadd_B = simplify(eqns2(3));
% fid = fopen(flnm, 'w');
% fprintf(fid, 'N_O = %s;\n', N_O);
% fprintf(fid, 'Ff_O = %s;\n', Ff_O);
% fprintf(fid, 'ttadd = %s;\n', ttadd_B);
% fclose(fid);

% solve using solve
% [solx, params, conds] = solve([eqn1_T_B(3), eqn1_F_B(1), eqn1_F_B(2)], [N, Ff, ttadd]);
% % save to matrix
% keyboard
% N_O = simplify((1));
% Ff_O = simplify(eqns2(2));
% ttadd_B = simplify(eqns2(3));
% fid = fopen(flnm, 'w');
% fprintf(fid, 'N_O = %s;\n', N_O);
% fprintf(fid, 'Ff_O = %s;\n', Ff_O);
% fprintf(fid, 'ttadd = %s;\n', ttadd_B);
% fclose(fid);

% % implicit equations
% fid = fopen('rollEqns_minus.txt', 'w');
% fprintf(fid, 'eq1 = %s;\n', eqn1_T_B(3));
% fprintf(fid, 'eq2 = %s;\n', eqn1_F_O(1));
% fprintf(fid, 'eq3 = %s;\n', eqn1_F_O(2));
% fclose(fid);

% explicit disk equations
solx = solve([eqn1_T_B(1), eqn1_F_B(2), eqn1_F_B(3)], [N, Ff, ttadd]);
fid = fopen('diskeqns_masses.txt', 'w');
fprintf(fid, 'N_O = %s;\n', solx.N);
fprintf(fid, 'Ff_O = %s;\n', solx.Ff);
fprintf(fid, 'ttadd = %s;\n', solx.ttadd);
fclose(fid);

disp('Solving equations complete');




% NOTES:
% If not slipping, then no friction force, use constraint instead (see MAE
% 589 notes)
% If slipping, then use friction force

% finish
toc
disp('Done!');
keyboard
    
end

function [eqns] = FirstTransport(pos, ang, t)
% [eqns] = FirstTransport(pos, ang) returns the three-dimensional vector
% corresponding to the inertial derivatives
% pos = B frame position vector
% vel = B frame derivative of pos
% ang = B frame angular velocity vector

eqns = simplify(diff(pos, t) + cross(ang, pos));

end

function [eqns] = SecondTransport(pos, angvel, t)
% [eqns] = SecondTransport(pos, vel, angvel, angaccl) returns the three-dimensional vector
% corresponding to the inertial derivatives
% pos = B frame position vector
% vel = B frame derivative of pos
% accl = B frame second derivative of pos
% angvel = B frame angular velocity vector
% angaccl = B frame angular acceleration

eqns = diff(pos, t, t) + 2*cross(angvel, diff(pos, t)) + ...
    cross(diff(angvel, t), pos) + cross(angvel, cross(angvel, pos));

end