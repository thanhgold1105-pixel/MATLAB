clc; clear; close all;

%% Problem 1a
% Nhập giá trị x và h
x = input('Nhap x: ');
h = input('Nhap h: ');

y = conv(x, h);

disp('Output y = ');
disp(y);

%% Problem 1b
n = -15:15;

x = double(n >= -10 & n < 5);   % x[n]
h = (2.^n) .* (n >= 0 & n <= 5); % h[n]

subplot(2,1,1);
stem(n, x);
title('x[n]');

subplot(2,1,2);
stem(n, h);
title('h[n]');

%% Problem 1c
L = length(x) + length(h) - 1;

X = fft(x, L);
H = fft(h, L);

Y = X .* H;

y_ifft = ifft(Y);

y_conv = conv(x, h);

subplot(2,1,1);
stem(y_conv);
title('Convolution (conv)');

subplot(2,1,2);
stem(real(y_ifft));
title('FFT-based result');