% MMCM Paramfile
% y = 50*sin(2*pi*t/200);
LL          = 0.2500;
UL          = 0.5500;
I_B_B       = 5.4495;
mCH         = 21.027;
R           = 0.7500;
mv          = 0.10000;   % maass vel
m           = 0.3000;
sp          = 100.0000; % Crazy High Number
ca          = 20.0000;
f_variable_sp = 0; %True
f_braking_sim = 0; % 1=true
time_of_braking = 600; %at t = 'X' seconds
A           = 50;  % Amplitude for valiable SP
T           = 20; %Time Period for variable SP
savename    = 'massvel_0p1mps.mat';  % standard other bits
expCname    = 'simC_RD2_sn_8.mat';
%expfile     = 'Test3_t1_SP50_filt.xlsx';
sn          = 1;
m1          = m;                         % kg, m1 value
m2          = m;                         % kg, m2 value
m3          = m;                         % kg, m3 value
m4          = m;                         % kg, m4 value
massFlag    = 'sim';               % 'sim' = simulate motion
g           = 9.81;               % ms^-2, Gravity's always bringin me down
mu          = 0;                 % static coefficient of friction
c           = 0;                  % roll rate damping coefficient
w_lim       = 0.00000001;          % rad/s, threshhold to drive Crr to zero at w goes to 0
Crr0        = 0.002;           % rolling resistance coefficient 
% use_ode     = 'ode45';
use_ode     = 'ode5';       % use ode5 for sim
% use_ode = 'ode5_Controls';
odefunct    = @odefunc_revB;
dt          = 0.1;               % s, time step for reporting (or sim if using fixed step)
ts          = 0; %5.15 works for 50_t1 % 2 and 2.5 
tf          = 400;
mm          = (UL + LL)/2;
ics         = [1, 0, UL, -LL, UL, -LL];  % [deg, deg/s, m, m, m, m] theta and theta dot initial conditions
% new bits for the kinematic stuff
massfunct   = 'revC';       % revA = cone angles, revB = kinematic simulation, revC = kinematics + d/dt
kP_vel      = 1.15;               % angular velocity control kP