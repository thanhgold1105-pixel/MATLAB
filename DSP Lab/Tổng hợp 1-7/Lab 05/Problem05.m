clc; clear; close all;

% Define numerator and denominator from difference equation
num = [0.01 0.03 0.015];
den = [1 -1.6 0.8];

n = 0:50;   % sample range

%% (a) Impulse input x[n] = delta[n]
[h, n_imp] = impz(num, den, length(n));

figure;
stem(n_imp, h, 'LineWidth', 1.5);
title('Impulse Response y[n] (x[n] = \delta[n])');
xlabel('n');
ylabel('Amplitude');
grid on;

%% (b) Step input x[n] = u[n]
[s, n_step] = stepz(num, den, length(n));

figure;
stem(n_step, s, 'LineWidth', 1.5);
title('Step Response y[n] (x[n] = u[n])');
xlabel('n');
ylabel('Amplitude');
grid on;