clc;
clear all;
close all;

%% Problem 2

f1 = 50;      % Hz
f2 = 60;      % Hz
f3 = 80;      % Hz

fs = 1000;    % Hz
Ts = 1/fs;

Nfft = 2048;

%% =========================================================
%% (a) Generate signal for L = 50
%% =========================================================

L = 50;

n = 0:L-1;

x = 2*sin(2*pi*f1*n*Ts) ...
    + sin(2*pi*f2*n*Ts) ...
    + 1.5*sin(2*pi*f3*n*Ts);

%% 2048-point FFT

X = fft(x,Nfft);

f = (0:Nfft-1)*(fs/Nfft);

%% Magnitude spectrum

figure;
plot(f,abs(X),'LineWidth',1.5);

xlim([0 200]);

xlabel('Frequency (Hz)');
ylabel('|X(f)|');
title('Magnitude Spectrum for L = 50');
grid on;

%% =========================================================
%% (b) Minimum number of samples Lmin
%% =========================================================

delta_f_min = min([abs(f2-f1), abs(f3-f2), abs(f3-f1)]);

Lmin = fs/delta_f_min;

disp(['Minimum number of samples Lmin = ', num2str(Lmin)]);

%% Generate signal using Lmin

L = Lmin;

n = 0:L-1;

x2 = 2*sin(2*pi*f1*n*Ts) ...
     + sin(2*pi*f2*n*Ts) ...
     + 1.5*sin(2*pi*f3*n*Ts);

%% FFT

X2 = fft(x2,Nfft);

%% Magnitude spectrum

figure;
plot(f,abs(X2),'LineWidth',1.5);

xlim([0 200]);

xlabel('Frequency (Hz)');
ylabel('|X(f)|');
title('Magnitude Spectrum for L_{min}');
grid on;

%% =========================================================
%% (c) Apply Hamming window
%% =========================================================

w = 0.54 - 0.46*cos(2*pi*n/(L-1));

xw = x2 .* w;

%% FFT after windowing

Xw = fft(xw,Nfft);

%% Magnitude spectrum

figure;
plot(f,abs(Xw),'LineWidth',1.5);

xlim([0 200]);

xlabel('Frequency (Hz)');
ylabel('|X(f)|');
title('Magnitude Spectrum with Hamming Window');
grid on;