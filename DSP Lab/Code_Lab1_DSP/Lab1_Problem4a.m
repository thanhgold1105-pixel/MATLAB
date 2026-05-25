clc
clear
close all

% Input frequencies
f1 = input('Enter f1: ');
f2 = input('Enter f2: ');
f3 = input('Enter f3: ');
f4 = input('Enter f4: ');

% Continuous time
t = 0:0.0001:5;

% Signal xa(t)
x_a = 2.5*cos(2*pi*f1*t) - 1.5*sin(2*pi*f2*t) + cos(2*pi*f3*t) + 0.5*cos(2*pi*f4*t);

figure
plot(t,x_a,'LineWidth',1.5)
title('Continuous Signal x_a(t)')
xlabel('Time')
ylabel('Amplitude')
grid on