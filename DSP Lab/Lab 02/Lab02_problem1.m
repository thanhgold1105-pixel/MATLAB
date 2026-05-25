% Problem 1
clc; clear; close all;

% Continuous-time signal (Original signal)
t = 0:0.0001:1;
xt = 8*cos(4*pi*t);

% Sampling
Ts = 0.01;
n = 0:100;
xs = 8*cos(4*pi*n*Ts);

% Quantization parameters
H = 8;
B = 3;

% Quantization
xq = my_quantizer(xs, H, B);

% Figure 1: Original vs Sampled
figure;
plot(t, xt, 'k', 'LineWidth', 1.5); hold on;
stem(n*Ts, xs, 'b');

legend('x(t)', 'x_s(nT_s)');
title('Original vs Sampled Signal');
xlabel('Time (s)');
ylabel('Amplitude');
grid on;

% Figure 2: Original vs Quantized
figure;
plot(t, xt, 'k', 'LineWidth', 1.5); hold on;
stairs(n*Ts, xq, 'r');
stem(n*Ts, xq, 'r');

legend('x(t)', 'x_q[n]');
title('Original vs Quantized Signal');
xlabel('Time (s)');
ylabel('Amplitude');
grid on;