clc; clear; close all;

% ===== PART 1: Convolution =====
n = 0:20;

x = cos(2*pi*n/3) .* (n>=0 & n<=13);
h = [1 1 1];

y = conv(x, h);
ny = 0:length(y)-1;

figure
stem(ny, y)
title('y[n] using convolution')
xlabel('n'); ylabel('Amplitude'); grid on;

% ===== PART 2: Z-transform =====
syms z n_sym

x_sym = cos(2*pi*n_sym/3)*(heaviside(n_sym)-heaviside(n_sym-14));

X = ztrans(x_sym, n_sym, z);
H = 1 + z^(-1) + z^(-2);
Y = X * H;

y_sym = iztrans(Y, z, n_sym);

disp('y[n] from Z-transform = ')
pretty(y_sym)

% ===== FIX: Convert symbolic -> numeric =====
n_plot = 0:20;

y_num = double(subs(y_sym, n_sym, n_plot));

figure
stem(n_plot, y_num)
title('y[n] from Z-transform')
xlabel('n'); ylabel('Amplitude'); grid on;