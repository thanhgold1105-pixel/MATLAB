clc;
clear all;
close all;

%% Parameters

fs = 30e6;        % 30 MHz
f0 = 2e6;         % 2 MHz
delta_f = 0.5e6; % 0.5 MHz

%% Get filter coefficients

[b,a] = ResonatorFilter(fs,f0,delta_f);

disp('Numerator coefficients:');
disp(b);

disp('Denominator coefficients:');
disp(a);

%% Frequency response

N = 2048;

[H,f] = freqz(b,a,N,fs);

%% Magnitude spectrum in dB

figure;

plot(f/1e6 , 20*log10(abs(H)) , 'LineWidth',1.5);

xlabel('Frequency (MHz)');
ylabel('Magnitude (dB)');

title('Frequency Response of Resonator Filter');

xlim([0 15]);

grid on;