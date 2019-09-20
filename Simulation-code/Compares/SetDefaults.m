function SetDefaults()
% SetDefaults(varargin) sets the default figure and text based objects for
% all MATLAB runs using the script. Variable inputs are used for different
% styles (jounral paper is default)

% Set journal paper style default
set(groot, 'defaultUicontrolFontName', 'Helvetica');
set(groot, 'defaultUitableFontName', 'Helvetica');
set(groot, 'defaultAxesFontName', 'Helvetica');
set(groot, 'defaultTextFontName', 'Helvetica');
set(groot, 'defaultUipanelFontName', 'Helvetica');
set(groot, 'defaultAxesFontSize', 12);   
set(groot, 'defaultFigureColor', [1, 1, 1]);
set(groot, 'defaultAxesXMinorGrid', 'on');
set(groot, 'defaultAxesYMinorGrid', 'on');
set(groot, 'defaultAxesZMinorGrid', 'on');
% set(groot, 'defaultAxesThetaMinorGrid', 'on');
% set(groot, 'defaultAxesRMinorGrid', 'on');

% set latex
set(0, 'defaulttextinterpreter', 'latex');
set(groot, 'defaultAxesTickLabelInterpreter','latex'); 
set(groot, 'defaultLegendInterpreter','latex');

end