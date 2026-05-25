clc; clear; close all;

n = -15:15;

% x[n]
x = double(n >= 0 & n <= 5);

% h[n]
h = exp(-n) .* (n >= -10 & n <= 10);

y = myconv(x, h);

figure;

subplot(3,1,1);
stem(n, x, 'filled');
title('x[n]');

subplot(3,1,2);
stem(n, h, 'filled');
title('h[n]');

subplot(3,1,3);
stem(y, 'filled');
title('y[n] = x[n] * h[n]');