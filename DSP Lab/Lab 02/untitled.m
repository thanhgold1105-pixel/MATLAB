clc;
clear;
close all;

%% Question 1(c)
% H(z) = (3 - 7z^-1 + 5z^-2) / (1 - 2.5z^-1 + z^-2)

num = [3 -7 5];
den = [1 -2.5 1];

%% ----------------------------------------
%% Pole-Zero Pattern in the Z-Plane
%% ----------------------------------------

figure;
zplane(num, den);
grid on;

title('Pole-Zero Plot of H(z)');

%% ----------------------------------------
%% Frequency Response of the System
%% ----------------------------------------

figure;
freqz(num, den, 1024);

title('Frequency Response of H(z)');
