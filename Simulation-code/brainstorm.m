% brainstorming

clc
close all
clear
SetDefaults

% parameters
syms tta xb yb zb m1 m2 m3 m4 mCH m r1 r2 r3 r4 R mT D yCM zCM
BCO = sym('BCO', [3,3]);
BCO(1, 1) = 1;
BCO(2, 1) = 0;
BCO(3, 1) = 0;
BCO(1, 2) = 0;
BCO(2, 2) = cos(tta);
BCO(3, 2) = -sin(tta);
BCO(1, 3) = 0;
BCO(2, 3) = sin(tta);
BCO(3, 3) = cos(tta);
r_B = sym('r_B', [3, 1]);
r_B(1) = xb;
r_B(2) = yb;
r_B(3) = zb;

% constraints
% r2 = r1 - 2*R;
% r4 = r3 - 2*R;
r2 = r1 - D;
r4 = r3 - D;
m1 = m;
m2 = m;
m3 = m;
m4 = m;

% calculate CM
r_CM_B = sym('r_CM_B', [3, 1]);
temp1 = (m1*r1 + m2*r2 + m3*r3 + m4*r4)/mT; 
r_CM_B(1) = 0;
r_CM_B(2) = (m1*r1 + m2*r2)/mT;
r_CM_B(3) = (m3*r3 + m4*r4)/mT; 

OCB = transpose(BCO);
% r_B = BCO*r_

% math
r_CM_B
OCB = transpose(BCO);
r_O = OCB*r_B
r_CM_O = simplify(OCB*r_CM_B)

% distill
eqn1 = yCM - r_CM_O(2) == 0;
eqn2 = zCM - r_CM_O(3) == 0;
sol1 = solve([eqn1, eqn2], [r1, r3]);
disp('r1 = ');
pretty(sol1.r1)
disp('r3 = ');
pretty(sol1.r3)