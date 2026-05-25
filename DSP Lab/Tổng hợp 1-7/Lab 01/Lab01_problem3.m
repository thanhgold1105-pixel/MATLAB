clc; clear; close all;

% Input angular frequencies
Omega0 = input('Enter Omega0: ');
Omega_s = input('Enter Omega_s: ');

% Sampling period
T_s = 2*pi/Omega_s;

% Time axis
t = 0:0.001:14;

% Signals
x1 = cos(Omega0*t);
x2 = cos((Omega0+Omega_s)*t);

% Sample points
n = 0:5;
t_s = n*T_s;

x1s = cos(Omega0*t_s);

figure

% Plot 1
subplot(3,1,1)
plot(t,x1,'b','LineWidth',1.5)
grid on
xlabel('Time')
ylabel('Amplitude')
title('x_1(t) = cos(\Omega_0 t)')

% Plot 2
subplot(3,1,2)
plot(t,x2,'r--','LineWidth',1.5)
grid on
xlabel('Time')
ylabel('Amplitude')
title('x_2(t) = cos((\Omega_0+\Omega_s)t)')

% Plot 3
subplot(3,1,3)
plot(t,x1,'b','LineWidth',1.5)
hold on
plot(t,x2,'r--','LineWidth',1.5)
stem(t_s,x1s,'k','filled')
grid on
xlabel('Time')
ylabel('Amplitude')
legend('x_1(t)','x_2(t)','Samples x(nT_s)')

title('Aliasing Demonstration')