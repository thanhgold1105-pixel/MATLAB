clc; clear; close all;

% Problem 4a
% H1(z)
num1 = [1 0 0];          % z^2
den  = [1 0.2 0.01];     % z^2 + 0.2z + 0.01

% H2(z) = z^{-2} * H1(z)
% => delay 2 sample → thêm 2 số 0 vào đầu numerator
num2 = [0 0 1 0 0];      

% Tính impulse response
[h1, n1] = impz(num1, den, 9); % n = 0→8
[h2, n2] = impz(num2, den, 9);

% Plot
subplot(2,1,1);
stem(n1, h1, 'filled');
title('Impulse Response of H1(z)');
grid on;

subplot(2,1,2);
stem(n2, h2, 'filled');
title('Impulse Response of H2(z) (delay 2)');
grid on;
