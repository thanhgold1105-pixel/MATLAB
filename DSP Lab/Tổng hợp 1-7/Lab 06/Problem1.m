clc; clear; close all;

%% ===== PROBLEM 1 =====
% Tín hiệu: x[n] = cos(pi*n/3), 0 <= n <= 10
n = 0:10;
x = cos(pi*n/3);

%% --- Khoảng 1: -3pi <= w <= 3pi ---
w1 = -3*pi:0.001:3*pi;

% Tính DTFT: X(w) = sum( x[n]*e^(-jwn) )
DTFT1 = zeros(1, length(w1));
for i = 1:length(w1)
    DTFT1(i) = sum(x .* exp(-1j * w1(i) * n));
end

figure;

% Magnitude
subplot(2,1,1);
plot(w1, abs(DTFT1));
title('Magnitude of DTFT (-3pi to 3pi)');
xlabel('Frequency (rad)');
ylabel('|X(w)|');
grid on;

% Phase
subplot(2,1,2);
plot(w1, angle(DTFT1));
title('Phase of DTFT (-3pi to 3pi)');
xlabel('Frequency (rad)');
ylabel('Phase (rad)');
grid on;

%% --- Khoảng 2: -7pi <= w <= 7pi ---
w2 = -7*pi:0.001:7*pi;

DTFT2 = zeros(1, length(w2));
for i = 1:length(w2)
    DTFT2(i) = sum(x .* exp(-1j * w2(i) * n));
end

figure;

% Magnitude
subplot(2,1,1);
plot(w2, abs(DTFT2));
title('Magnitude of DTFT (-7pi to 7pi)');
xlabel('Frequency (rad)');
ylabel('|X(w)|');
grid on;

% Phase
subplot(2,1,2);
plot(w2, angle(DTFT2));
title('Phase of DTFT (-7pi to 7pi)');
xlabel('Frequency (rad)');
ylabel('Phase (rad)');
grid on;