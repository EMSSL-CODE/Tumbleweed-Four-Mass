% Test 3 Exp and Sim Comparison Files
% Rover number: 5
LL          = 0.3000;
UL          = 0.7400;
I_B_B       = 14.1072;
mCH         = 29.3850;
R           = 1.0000;
mv          = 1.0000;
m           = 0.9000;
sp          = 50.0000;
ca          = 20.0000;
savename    = 'Compare2B_50_t2.mat';  % standard other bits
expCname    = 'simC_RD2_sn_8.mat';
expfile     = 'Test3_t2_SP50_filt.xlsx';
sn          = 1;
m1          = m;                         % kg, m1 value
m2          = m;                         % kg, m2 value
m3          = m;                         % kg, m3 value
m4          = m;                         % kg, m4 value
massFlag    = 'exp';               % 'sim' = simulate motion
g           = 9.81;               % ms^-2, Gravity's always bringin me down
mu          = 0;                 % static coefficient of friction
c           = 0;                  % roll rate damping coefficient
w_lim       = 0.00000001;          % rad/s, threshhold to drive Crr to zero at w goes to 0
Crr0        = 0.002;           % rolling resistance coefficient 
use_ode     = 'ode45';       % use ode5 for sim
% use_ode = 'ode5_Controls';
odefunct    = @odefunc_revB;
dt          = 0.01;               % s, time step for reporting (or sim if using fixed step)
ts          = 0;
tf          = 60;
mm          = (UL + LL)/2;
ics         = [0, 5, UL, -LL, UL, -LL];  % [deg, deg/s, m, m, m, m] theta and theta dot initial conditions
% new bits for the kinematic stuff
massfunct   = 'revB';       % revA = cone angles, revB = kinematic simulation
kP_vel      = 1.15;               % angular velocity control kP