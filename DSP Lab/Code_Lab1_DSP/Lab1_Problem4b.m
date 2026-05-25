clc
clear
close all

% Enter frequencies
f1 = input('Enter f1: ');
f2 = input('Enter f2: ');
f3 = input('Enter f3: ');
f4 = input('Enter f4: ');

% Find maximum frequency
fmax = max([f1 f2 f3 f4]);

% Sampling frequency
fs = 5*fmax;
Ts = 1/fs;

% Continuous time
t = 0:0.001:1;

% Original signal
xa = 2.5*cos(2*pi*f1*t) - 1.5*sin(2*pi*f2*t) + cos(2*pi*f3*t) + 0.5*cos(2*pi*f4*t);

% Sample times
n = 0:Ts:1;

% Sampled signal
xn = 2.5*cos(2*pi*f1*n) - 1.5*sin(2*pi*f2*n) + cos(2*pi*f3*n) + 0.5*cos(2*pi*f4*n);

figure

subplot(3,1,1)
plot(t,xa)
title('Original Signal x_a(t)')
grid on

subplot(3,1,2)
stem(n,xn)
title('Sampled Signal x[n]')
grid on

subplot(3,1,3)
plot(t,xa)
hold on
stem(n,xn,'r')
title('Samples on Original Signal')
grid on