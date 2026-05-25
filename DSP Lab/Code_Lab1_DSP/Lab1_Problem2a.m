clc
clear
close all

% Sampling parameters
fs = 5;        % samples per ms (5 kHz)
Ts = 1/fs;     % sampling period

% Time axis (0 to 2 ms)
t = 0:0.001:2;

% Original signal
x = cos(2*pi*t) + cos(8*pi*t) + cos(12*pi*t);

% Aliased signal
xa = 3*cos(2*pi*t);

% Sample times
n = 0:Ts:2;

% Sample values
xn = cos(2*pi*n) + cos(8*pi*n) + cos(12*pi*n);

% Plot
figure
plot(t,x,'b','LineWidth',1.5)
hold on
plot(t,xa,'r--','LineWidth',1.5)
stem(n,xn,'k','filled')

xlabel('t (ms)')
ylabel('Amplitude')
title('Aliasing Demonstration')
legend('x(t)','x_a(t)','Samples x(nT_s)')
grid on