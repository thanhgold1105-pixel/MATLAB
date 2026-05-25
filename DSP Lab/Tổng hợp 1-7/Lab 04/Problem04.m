clc; clear; close all;

%% Problem a
syms z n

% Input signal
x = 0.8^n * heaviside(n);

% Z-transform
X = ztrans(x, n, z);

% Solve for Y(z)
Y = (X + z^(-1)*X) / (1 + 1.5*z^(-1) + 0.5*z^(-2));

% Inverse Z-transform
y = iztrans(Y, z, n);

disp('Solution y[n] = ')
pretty(y)

%% Problem b
Y2 = (X + z^(-1)*X) / (1 - z^(-1));

y2 = iztrans(Y2, z, n);

disp('Solution y2[n] = ')
pretty(y2)

%% Plotting
n_vals = 0:20;

y_vals = double(subs(y, n, n_vals));

stem(n_vals, y_vals)
title('y[n] from 0 to 20')
xlabel('n')
ylabel('Amplitude')