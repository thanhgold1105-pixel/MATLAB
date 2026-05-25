clc; clear; close all;

%% Problem 1a
% Nhập tín hiệu từ bàn phím
x = input('Nhap x: ');
h = input('Nhap h: ');

% Convolution dùng hàm có sẵn
y = conv(x, h);

disp('Output y(n) = ');
disp(y);

%% Problem 1b
% Trục thời gian
n = -15:15;

% x[n] = u[n+10] - u[n-5]
x_b = double(n >= -10 & n < 5);

% h[n] = 2^n u[n], n = 0:5
h_b = (2.^n) .* (n >= 0 & n <= 5);

% Vẽ tín hiệu
figure;
subplot(2,1,1);
stem(n, x_b, 'filled');
title('x[n] = u[n+10] - u[n-5]');
xlabel('n'); ylabel('x[n]');

subplot(2,1,2);
stem(n, h_b, 'filled');
title('h[n] = 2^n u[n], n = 0:5');
xlabel('n'); ylabel('h[n]');

%% Problem 1c
% Convolution trực tiếp
y_conv = conv(x_b, h_b);

% Zero padding để FFT đúng
L = length(x_b) + length(h_b) - 1;

X = fft(x_b, L);
H = fft(h_b, L);

% Nhân trong miền tần số
Y = X .* H;

% IFFT để quay lại time domain
y_ifft = ifft(Y);

% Trục n cho output
n_y = (min(n)+min(n)) : (max(n)+max(n));

% Plot so sánh
figure;

subplot(2,1,1);
stem(y_conv, 'filled');
title('y[n] using conv()');
xlabel('n'); ylabel('y[n]');

subplot(2,1,2);
stem(real(y_ifft), 'filled');
title('y[n] using FFT (IFFT of X*H)');
xlabel('n'); ylabel('y[n]');