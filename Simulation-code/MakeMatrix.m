function [dataout, tta, ttad] = MakeMatrix(filename, sheet)
% 

% read in paurav file
if isempty(sheet) == 1
    exp2_fca_40 = xlsread(filename);
else 
    exp2_fca_40 = xlsread(filename, sheet);
end 

% angles
tta = exp2_fca_40(:, 3);
ttad = exp2_fca_40(:, 4);

% find sample rate
fs = 1/(mean(exp2_fca_40(2:end, 2) - exp2_fca_40(1:end - 1, 2)));
fpass = 0.01;

% filter position
% x1r = exp2_fca_40(:, 6)/100;
% x2r = -exp2_fca_40(:, 8)/100;
% y3r = exp2_fca_40(:, 10)/100;
% y4r = -exp2_fca_40(:, 12)/100;
x1r = exp2_fca_40(:, 5)/100;
x2r = -exp2_fca_40(:, 7)/100;
y3r = exp2_fca_40(:, 9)/100;
y4r = -exp2_fca_40(:, 11)/100;


% x1f = lowpass(x1r, fpass, fs);
% x2f = lowpass(x2r, fpass, fs);
% y3f = lowpass(y3r, fpass, fs);
% y4f = lowpass(y4r, fpass, fs);
% x1f(1:20) = x1r(1:20);
% x2f(1:20) = x2r(1:20);
% y3f(1:20) = y3r(1:20);
% y4f(1:20) = y4r(1:20);

x1f = x1r;
x2f = x2r;
y3f = y3r;
y4f = y4r;


% compute velocity
tv = exp2_fca_40(:, 2);
x1dr = 0*exp2_fca_40(:, 2);
x2dr = x1dr;
y3dr = x1dr;
y4dr = x1dr;
x1drr = 0*exp2_fca_40(:, 2);
x2drr = x1drr;
y3drr = x1drr;
y4drr = x1drr;
for i1 = 2:length(x1dr)
    x1dr(i1) = (x1f(i1) - x1f(i1 - 1))/(tv(i1) - tv(i1 - 1));
    x2dr(i1) = (x2f(i1) - x2f(i1 - 1))/(tv(i1) - tv(i1 - 1));
    y3dr(i1) = (y3f(i1) - y3f(i1 - 1))/(tv(i1) - tv(i1 - 1));
    y4dr(i1) = (y4f(i1) - y4f(i1 - 1))/(tv(i1) - tv(i1 - 1));
    x1drr(i1) = (x1r(i1) - x1r(i1 - 1))/(tv(i1) - tv(i1 - 1));
    x2drr(i1) = (x2r(i1) - x2r(i1 - 1))/(tv(i1) - tv(i1 - 1));
    y3drr(i1) = (y3r(i1) - y3r(i1 - 1))/(tv(i1) - tv(i1 - 1));
    y4drr(i1) = (y4r(i1) - y4r(i1 - 1))/(tv(i1) - tv(i1 - 1));
end
% x1df = lowpass(x1dr, fpass, fs);
% x2df = lowpass(x2dr, fpass, fs);
% y3df = lowpass(y3dr, fpass, fs);
% y4df = lowpass(y4dr, fpass, fs);
x1df = x1dr;
x2df = x2dr;
y3df = y3dr;
y4df = y4dr;

% compute acceleration
x1ddr = 0*exp2_fca_40(:, 2);
x2ddr = x1dr;
y3ddr = x1dr;
y4ddr = x1dr;
x1ddrr = 0*exp2_fca_40(:, 2);
x2ddrr = x1drr;
y3ddrr = x1drr;
y4ddrr = x1drr;
for i1 = 2:length(x1ddr)
    x1ddr(i1) = (x1df(i1) - x1df(i1 - 1))/(tv(i1) - tv(i1 - 1));
    x2ddr(i1) = (x2df(i1) - x2df(i1 - 1))/(tv(i1) - tv(i1 - 1));
    y3ddr(i1) = (y3df(i1) - y3df(i1 - 1))/(tv(i1) - tv(i1 - 1));
    y4ddr(i1) = (y4df(i1) - y4df(i1 - 1))/(tv(i1) - tv(i1 - 1));
    x1ddrr(i1) = (x1drr(i1) - x1drr(i1 - 1))/(tv(i1) - tv(i1 - 1));
    x2ddrr(i1) = (x2drr(i1) - x2drr(i1 - 1))/(tv(i1) - tv(i1 - 1));
    y3ddrr(i1) = (y3drr(i1) - y3drr(i1 - 1))/(tv(i1) - tv(i1 - 1));
    y4ddrr(i1) = (y4drr(i1) - y4drr(i1 - 1))/(tv(i1) - tv(i1 - 1));
end
% x1ddf = lowpass(x1ddr, fpass, fs);
% x2ddf = lowpass(x2ddr, fpass, fs);
% y3ddf = lowpass(y3ddr, fpass, fs);
% y4ddf = lowpass(y4ddr, fpass, fs);


% % form the matrix - filtered
% dataout = [tv, x1f, x2f, y3f, y4f, x1df, x2df, y3df, y4df, x1ddf, x2ddf, y3ddf, y4ddf]; 

% form the matrix - raw
% dataout = [tv, x1r, x2r, y3r, y4r, x1dr, x2dr, y3dr, y4dr, x1ddr, x2ddr, y3ddr, y4ddr]; 

% for the matrix - super raw!
dataout = [tv, x1r, x2r, y3r, y4r, x1drr, x2drr, y3drr, y4drr, x1ddrr, x2ddrr, y3ddrr, y4ddrr]; 


% % compare values
% figure('Color', 'w');
% subplot(4, 1, 1);
% hold on
% plot(tv, x1r, '.');
% plot(tv, x1f, '-');
% ylabel('Position [m]');
% grid on
% subplot(4, 1, 2);
% hold on
% plot(tv, x2r, '.');
% plot(tv, x2f, '-');
% ylabel('Position [m]');
% grid on
% subplot(4, 1, 3);
% hold on
% plot(tv, y3r, '.');
% plot(tv, y3f, '-');
% ylabel('Position [m]');
% grid on
% subplot(4, 1, 4);
% hold on
% plot(tv, y4r, '.');
% plot(tv, y4f, '-');
% ylabel('Position [m]');
% grid on
% 
% figure('Color', 'w');
% subplot(4, 1, 1);
% hold on
% plot(tv, x1dr, '.');
% plot(tv, x1df, '-');
% ylabel('Velocity [m/s]');
% grid on
% subplot(4, 1, 2);
% hold on
% plot(tv, x2dr, '.');
% plot(tv, x2df, '-');
% ylabel('Velocity [m/s]');
% grid on
% subplot(4, 1, 3);
% hold on
% plot(tv, y3dr, '.');
% plot(tv, y3df, '-');
% ylabel('Velocity [m/s]');
% grid on
% subplot(4, 1, 4);
% hold on
% plot(tv, y4dr, '.');
% plot(tv, y4df, '-');
% ylabel('Velocity [m/s]');
% grid on
% 
% figure('Color', 'w');
% subplot(4, 1, 1);
% hold on
% plot(tv, x1ddr, '.');
% plot(tv, x1ddf, '-');
% ylabel('Acceleration [m/s/s]');
% grid on
% subplot(4, 1, 2);
% hold on
% plot(tv, x2ddr, '.');
% plot(tv, x2ddf, '-');
% ylabel('Acceleration [m/s/s]');
% grid on
% subplot(4, 1, 3);
% hold on
% plot(tv, y3ddr, '.');
% plot(tv, y3ddf, '-');
% ylabel('Acceleration [m/s/s]');
% grid on
% subplot(4, 1, 4);
% hold on
% plot(tv, y4ddr, '.');
% plot(tv, y4ddf, '-');
% ylabel('Acceleration [m/s/s]');
% grid on



end