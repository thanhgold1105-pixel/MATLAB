clc; clear; close all;
syms z n

%% X1
% Define X(z)
X1 = (12*z^4 - 38*z^3 + 11*z^2 + 3*z + 54) / (z^4 - 5*z^3 + 6*z^2);

% Display X(z)
disp('X1(z) = ')
pretty(X1)

% Perform partial fraction expansion
X1_pf = partfrac(X1, z);
disp('Partial Fraction Form:')
pretty(X1_pf)

% Compute inverse Z-transform
x1 = iztrans(X1);
disp('x1[n] = ')
pretty(x1)

%% X2
% Define X(z)
X2 = (2*z^2 + z - 1) / (z^3 - 3*z + 2);

disp('X2(z) = ')
pretty(X2)

% Partial fraction
X2_pf = partfrac(X2, z);
disp('Partial Fraction Form:')
pretty(X2_pf)

% Inverse Z-transform
x2 = iztrans(X2);
disp('x2[n] = ')
pretty(x2)

%% X3
% Define X(z)
X3 = (5 - 11*z^(-1)) / (1 - 5*z^(-1) + 6*z^(-2));

disp('X3(z) = ')
pretty(X3)

% Partial fraction
X3_pf = partfrac(X3, z);
disp('Partial Fraction Form:')
pretty(X3_pf)

% Inverse Z-transform
x3 = iztrans(X3);
disp('x3[n] = ')
pretty(x3)
