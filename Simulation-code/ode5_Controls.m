function Y = ode5_Controls(odefun,tspan,y0,varargin)
%ODE5  Solve differential equations with a non-adaptive method of order 5.
%   Y = ODE5(ODEFUN,TSPAN,Y0) with TSPAN = [T1, T2, T3, ... TN] integrates 
%   the system of differential equations y' = f(t,y) by stepping from T0 to 
%   T1 to TN. Function ODEFUN(T,Y) must return f(t,y) in a column vector.
%   The vector Y0 is the initial conditions at T0. Each row in the solution 
%   array Y corresponds to a time specified in TSPAN.
%
%   Y = ODE5(ODEFUN,TSPAN,Y0,P1,P2...) passes the additional parameters 
%   P1,P2... to the derivative function as ODEFUN(T,Y,P1,P2...). 
%
%   This is a non-adaptive solver. The step sequence is determined by TSPAN
%   but the derivative function ODEFUN is evaluated multiple times per step.
%   The solver implements the Dormand-Prince method of order 5 in a general 
%   framework of explicit Runge-Kutta methods.
%
%   Example 
%         tspan = 0:0.1:20;
%         y = ode5(@vdp1,tspan,[2 0]);  
%         plot(tspan,y(:,1));
%     solves the system y' = vdp1(t,y) with a constant step size of 0.1, 
%     and plots the first component of the solution.   
%
% CDY addition for controls work
% varargin name/value pairs
%   LB | lower bounds for states, used to model saturation in controls
%        problems. Should be a n x 1 vector where length(y0) = n.
%   UB | upper bounds for states, used to model saturation in controls
%        problems. Should be a n x 1 vector where length(y0) = n.

% handle varargin - CDY
LB = y0*0 + -Inf;
UB = y0*0 + Inf;
if isempty(varargin) ~= 1
    for i1 = 1:length(varargin)/2
        ind1 = 2*(i1 - 1) + 1;
        ind2 = 2*(i1 - 1) + 2;
        switch varargin{ind1}
            case 'LB'
                LB = varargin{ind2};
            case 'UB'
                UB = varargin{ind2};
        end
    end
end

if ~isnumeric(tspan)
  error('TSPAN should be a vector of integration steps.');
end

if ~isnumeric(y0)
  error('Y0 should be a vector of initial conditions.');
end

h = diff(tspan);
if any(sign(h(1))*h <= 0)
  error('Entries of TSPAN are not in order.') 
end  

try
  % f0 = feval(odefun,tspan(1),y0,varargin{:});
  f0 = feval(odefun,tspan(1),y0);
catch
  msg = ['Unable to evaluate the ODEFUN at t0,y0. ',lasterr];
  error(msg);  
end  

y0 = y0(:);   % Make a column vector.
if ~isequal(size(y0),size(f0))
  error('Inconsistent sizes of Y0 and f(t0,y0).');
end  

neq = length(y0);
N = length(tspan);
Y = zeros(neq,N);

% Method coefficients -- Butcher's tableau
%  
%   C | A
%   --+---
%     | B

C = [1/5; 3/10; 4/5; 8/9; 1];

A = [ 1/5,          0,           0,            0,         0
      3/40,         9/40,        0,            0,         0
      44/45        -56/15,       32/9,         0,         0
      19372/6561,  -25360/2187,  64448/6561,  -212/729,   0
      9017/3168,   -355/33,      46732/5247,   49/176,   -5103/18656];

B = [35/384, 0, 500/1113, 125/192, -2187/6784, 11/84];

% More convenient storage
A = A.'; 
B = B(:);      

nstages = length(B);
F = zeros(neq,nstages);

Y(:,1) = y0;
for i = 2:N
  ti = tspan(i-1);
  hi = h(i-1);
  yi = Y(:,i-1);  
  
  % General explicit Runge-Kutta framework
  % F(:,1) = feval(odefun,ti,yi,varargin{:});  
  F(:,1) = feval(odefun,ti,yi);  
  for stage = 2:nstages
    tstage = ti + C(stage-1)*hi;
    ystage = yi + F(:,1:stage-1)*(hi*A(1:stage-1,stage-1));
    % F(:,stage) = feval(odefun,tstage,ystage,varargin{:});
    F(:,stage) = feval(odefun,tstage,ystage);
  end  
  Y(:,i) = yi + F*(hi*B);
  
  % check for saturation conditions
  for j1 = 1:length(Y(:,i))
      if Y(j1,i) > UB(j1)
          Y(j1, i) = UB(j1);
      elseif Y(j1,i) < LB(j1)
          Y(j1, i) = LB(j1);
      end
  end
  
end
Y = Y.';
