% Problem 2: DFT of x[n] = 3*cos(2*pi*n/3), 0 <= n <= 64
clc; clear; close all;

n = 0:64;
x = 3 * cos(2*pi*n/3);

% Compute DFT using FFT
Xk = fft(x);        % fft(x) trả về N điểm, với N = length(x)
N = length(Xk);     % N = 65 (vì n = 0:64 → có 65 phần tử)
k = 0:N-1;          % k = 0, 1, 2, ..., 64 → đúng với định nghĩa DFT

figure;

% 1. Magnitude
subplot(4,1,1);
stem(k, abs(Xk), 'filled');
title('Magnitude |X_k|');
xlabel('k');
ylabel('|X_k|');
xlim([-0.5, N-0.5]);

% 2. Phase (Angle)
subplot(4,1,2);
stem(k, angle(Xk), 'filled');
title('Phase \angle X_k');
xlabel('k');
ylabel('\angle X_k (rad)');
xlim([-0.5, N-0.5]);

% 3. Real Part
subplot(4,1,3);
stem(k, real(Xk), 'filled');
title('Real Part of X_k');
xlabel('k');
ylabel('Re\{X_k\}');
xlim([-0.5, N-0.5]);

% 4. Imaginary Part
subplot(4,1,4);
stem(k, imag(Xk), 'filled');
title('Imaginary Part of X_k');
xlabel('k');
ylabel('Im\{X_k\}');
xlim([-0.5, N-0.5]);

sgtitle('DFT of x[n] = 3cos(2\pin/3), 0 \leq n \leq 64');