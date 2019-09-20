function [angn] = RelToAbs(ango, varargin)
% Converts a vector of angles bounded [0, 360] to absolute angles. 
%
% INPUTS
%   ango = n x 1 vector of angles bounded by [0, 360]
% 
% OUTPUTS
%   angn = n x 1 vector of angles not bounded]
%
% VARARGIN
%   'units' | 'deg' (default), 'rad'
%   Change the units from deg to radians.
%   'limit' | '10' (default)
%   Changes the threshhold (in deg) for switching

% errors
if isnumeric(ango) ~= 1
    error('ango is not numeric vector.');
end
if sum(isnan(ango)) > 0
    error('ango cannot contain NaN entries.');
end
sz = size(ango);
if min(sz) ~= 1
    error('ango must be either an n x 1 or a 1x n vector.');
end
if iscolumn(ango) ~= 1
    ango = transpose(ango);
end
% varargin
ub = 360;
lb = 0;
fnsh = 1;
limz = 5;  % limit for changing in deg. 
if isempty(varargin) ~= 1
    for i1 = 1:length(varargin)/2
        arg1 = varargin{2*(i1 - 1) + 1};
        arg2 = varargin{2*(i1 - 1) + 2};
        switch arg1
            case 'units'
                if strcmp(arg2, 'deg') == 1
                    ub = 360;
                    lb = 0;
                    fnsh = 1;
                elseif strcmp(arg2, 'rad') == 1
                    ango = ango.*(180/pi);
                    fnsh = pi/180;
                else
                    error(['Value of ', char(arg2), ' not recognized.']);
                end
            case 'limit'
                if isnumeric(arg2) ~= 1
                    error('limit argument must be numeric value.');
                else
                    limz = arg2;
                end
            otherwise
                error(['Name of ', char(arg1), ' not recognized.']);
        end
    end
end
% convert! - old method, doesn't work
angn = NaN*ango;                % preallocate
angn(1) = ango(1);              % get first angle entry, dont care about value
for i1 = 2:length(ango)
    % check to make sure not crossing threashhold 
    if ango(i1 - 1) >= ub - limz && ango(i1) <= lb + limz
        delt = (ub - ango(i1 - 1)) + (ango(i1) - lb);
    elseif ango(i1 - 1) <= lb + limz && ango(i1) >= ub - limz
        delt = (lb - ango(i1 - 1)) + (ango(i1) - ub);
    else
        delt = ango(i1) - ango(i1 - 1);
    end    
    % take old plus new for angles
    angn(i1) = angn(i1 - 1) + delt;
end
% convert if needed
angn = angn.*fnsh;
end