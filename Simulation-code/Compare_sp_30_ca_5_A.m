% Rover number: 5
LL = 0.2500;
UL = 0.5500;
I_B_B = 5.4495;
mCH = 21.0270;
R = 0.7500;
mv = 0.2000;
m = 0.6000;
sp = 30.0000;
ca = 5.0000;
savename = 'Compare3A.mat';  % standard other bits
m1 = m;                         % kg, m1 value
m2 = m;                         % kg, m2 value
m3 = m;                         % kg, m3 value
m4 = m;                         % kg, m4 value
massFlag = 'sim';               % 'sim' = simulate motion
g = 9.81;               % ms^-2, Gravity's always bringin me down
mu = 0;                 % static coefficient of friction
c = 0;                  % roll rate damping coefficient
w_lim = 0.00000001;          % rad/s, threshhold to drive Crr to zero at w goes to 0
Crr0 = 0.002;           % rolling resistance coefficient 
% use_ode = 'ode45';       % use ode5 for sim
% use_ode = 'ode5_Controls';
use_ode = ode5;
odefunct = @odefunc_revB;
dt = 0.01;               % s, time step for reporting (or sim if using fixed step)
ts = 0;
tf = 60;
mm = (UL + LL)/2;
ics = [0, 5, UL, -LL, UL, -LL];  % [deg, deg/s, m, m, m, m] theta and theta dot initial conditions
% new bits for the kinematic stuff
massfunct = 'revA';       % revA = cone angles, revB = kinematic simulation
kP_vel = 0.15;               % angular velocity control kP