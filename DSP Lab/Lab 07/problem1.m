clc;
clear all;
close all;

%% Problem 1

% Transfer function:
% H(z) = (1 + 0.7z^-1 + 0.6z^-2)
%        ------------------------
%        (1 - 1.5z^-1 + 0.9z^-2)

b = [1 0.7 0.6];      % numerator coefficients
a = [1 -1.5 0.9];     % denominator coefficients

%% (b) Impulse response using filter()

N = 100;              % first 100 samples

x = [1 zeros(1,N-1)]; % impulse signal delta[n]

h = filter(b,a,x);    % impulse response

n = 0:N-1;

figure;
stem(n,h,'filled');
xlabel('n');
ylabel('h[n]');
title('Impulse Response');
grid on;

%% (c) Pole-zero plot

figure;
zplane(b,a);
title('Pole-Zero Plot');

%% Magnitude and phase spectra

H = fft(h,N);

f = 0:N-1;

% Magnitude spectrum in dB
magH = 20*log10(abs(H));

figure;
plot(f,magH,'LineWidth',1.5);
xlabel('Frequency Index');
ylabel('Magnitude (dB)');
title('Magnitude Spectrum');
grid on;

% Phase spectrum in degree
phaseH = angle(H)*180/pi;

figure;
plot(f,phaseH,'LineWidth',1.5);
xlabel('Frequency Index');
ylabel('Phase (degree)');
title('Phase Spectrum');
grid on;