% Step 1: Define signals
n = 0:20;   % Define time range

% Input signal
x = 2*cos(pi/3*n) .* (n>=0 & n<14);

% Impulse response
h = [1 1 1];

% Step 2: Convolution
y = conv(x, h);

% Plot
stem(y)
title('Output y[n] using convolution')
xlabel('n')
ylabel('Amplitude')

% Step 3: Using Z-transform
syms z n

x_sym = 2*cos(pi/3*n)*(heaviside(n)-heaviside(n-14));

X = ztrans(x_sym, n, z);

H = 1 + z^(-1) + z^(-2);

Y = X * H;

y_sym = iztrans(Y, z, n);

disp('y[n] from Z-transform = ')
pretty(y_sym)