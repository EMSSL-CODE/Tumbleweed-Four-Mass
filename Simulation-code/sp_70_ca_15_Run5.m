% Rover number: 3
LL = 0.2500;
UL = 0.5500;
I_B_B = 5.4495;
mCH = 21.0270;
R = 0.7500;
mv = 0.2000;
m = 0.6000;
sp = 70.0000;
ca = 15.0000;
savename = 'Run5.mat';% standard other bits
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
use_ode = 'ode45';       % use ode5 for sim
odefunct = @odefunc_revA;
dt = 0.005;               % s, time step for reporting (or sim if using fixed step)
ts = 0;
tf = 60;
ics = [0, 5, UL, -LL, UL, -LL];  % [deg, deg/s, m, m, m, m] theta and theta dot initial conditions
