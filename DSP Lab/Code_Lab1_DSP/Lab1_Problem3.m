clc; clear; close all;

% Input angular frequencies
Omega0  = input('Enter Omega0 (rad/s): ');
Omega_s = input('Enter Omega_s (rad/s): ');

% Sampling period
T_s = 2*pi/Omega_s;

% Number of samples to display
N = 10;
t_end = N*T_s;

% Continuous-time axis with fine resolution
% (dt much smaller than the period of x2, the higher-freq signal)
dt = min(T_s, 2*pi/(Omega0+Omega_s)) / 100;
t  = 0:dt:t_end;

% Continuous signals
x1 = cos(Omega0*t);
x2 = cos((Omega0+Omega_s)*t);

% Sample times and sampled values
n   = 0:N;
t_n = n*T_s;
x1s = cos(Omega0*t_n);
x2s = cos((Omega0+Omega_s)*t_n);   % equals x1s — demonstrate overlap

figure

% Plot 1: x1(t)
subplot(3,1,1)
plot(t, x1, 'b', 'LineWidth', 1.5); grid on
xlabel('t'); ylabel('Amplitude')
title('x_1(t) = cos(\Omega_0 t)')

% Plot 2: x2(t)
subplot(3,1,2)
plot(t, x2, 'r', 'LineWidth', 1.5); grid on
xlabel('t'); ylabel('Amplitude')
title('x_2(t) = cos((\Omega_0+\Omega_s)t)')

% Plot 3: both continuous signals + both sample sets to show they overlap
subplot(3,1,3)
plot(t, x1, 'b', 'LineWidth', 1.5); hold on
plot(t, x2, 'r--', 'LineWidth', 1.5)
stem(t_n, x1s, 'k', 'filled')          % filled black dots
stem(t_n, x2s, 'mo', 'LineWidth', 1.2) % open magenta circles on top
grid on
xlabel('t'); ylabel('Amplitude')
title('Sampled x_1 and x_2 coincide at t = nT_s')
legend('x_1(t)', 'x_2(t)', 'x_1(nT_s)', 'x_2(nT_s)')