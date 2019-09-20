% parameter file for tumbleweed roll test file, CDY 2019-07-15
LL = 0.20;          % m, lower limit of mass travel
UL = 0.3621;        % m, upper limit of mass travel
I_B_B = 1.6607;     % kg-m2, chassis inertia about roll axis
mCH = 14.809;       % kg, chassis mass
R = 0.50;           % m, chassis radius
mv = 0.2;                       % m/s, mass velocity max
m = 0.3;
sp = 40;
ca = 10;                        % deg, 1/2 total cone angle
savename = 'Nond1.mat';
% standard other bits
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