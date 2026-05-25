clc
clear
close all

fs = 10;        % samples/ms (10 kHz)
Ts = 1/fs;

t = 0:0.001:2;

% Original signal
x = cos(2*pi*t) + cos(8*pi*t) + cos(12*pi*t);

% Aliased signal
xa = cos(2*pi*t) + 2*cos(8*pi*t);

% Sample times
n = 0:Ts:2;

% Sample values
xn = cos(2*pi*n) + cos(8*pi*n) + cos(12*pi*n);

figure
plot(t,x,'b','LineWidth',1.5)
hold on
plot(t,xa,'r--','LineWidth',1.5)
stem(n,xn,'k','filled')

xlabel('t (ms)')
ylabel('Amplitude')
title('Aliasing when f_s = 10kHz')
legend('x(t)','x_a(t)','Samples')
grid on