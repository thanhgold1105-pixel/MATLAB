% Problem 2
clc; clear; close all;

% Continuous-time signal
t = 0:0.0001:1;
xt = 8*cos(4*pi*t);

% Sampling
Ts = 0.01;
n = 0:100;
xs = 8*cos(4*pi*n*Ts);

% Quantization parameters
H = 8;
B = 3;

% Quantization (LẤY CẢ i)
[xq, idx] = my_quantizer(xs, H, B);

% Quantization error
epsilon = xs - xq;

% Plot Quantization Error
figure;
stem(n, epsilon, 'filled');
title('Quantization Error \epsilon[n]');
xlabel('n');
ylabel('Error');
grid on;

% Encoding (DÙNG idx)
bits = encoder(idx);
disp(bits);