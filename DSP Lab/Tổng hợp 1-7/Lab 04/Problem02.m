clc; clear; close all;
syms n z

%% H1
% Define signal
h1 = 0.8^n * heaviside(n);

% Compute Z-transform
H1 = ztrans(h1);

disp('H1(z) = ')
pretty(H1)

%% H2
h2 = heaviside(n) - heaviside(n-10);

H2 = ztrans(h2);

disp('H2(z) = ')
pretty(H2)

%% H3
syms w0

h3 = cos(w0*n) * heaviside(n);

H3 = ztrans(h3);

disp('H3(z) = ')
pretty(H3)

%% H4
h4 = (0.8^n)*cos(w0*n)*heaviside(n);

H4 = ztrans(h4);

disp('H4(z) = ')
pretty(H4)