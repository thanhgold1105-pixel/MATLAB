clc; clear; close all;

num = [1 -0.4];
den = [1 -0.5 0.24];

[h, n] = impz(num, den, 20);
