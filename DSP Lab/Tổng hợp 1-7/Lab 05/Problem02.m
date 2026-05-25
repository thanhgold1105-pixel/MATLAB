clc; clear; close all;

% ================== PROBLEM 2 ==================
% H(z) = (8z^2 + 10z - 6)/(z^3 + 2z^2 - z - 2)

% Khai báo tử và mẫu
num = [8 10 -6];        % 8z^2 + 10z - 6
den = [1 2 -1 -2];      % z^3 + 2z^2 - z - 2

% ================== PLOT POLE-ZERO ==================
figure;

zplane(num, den);
% zplane:
% - 'o' là zero (nghiệm tử)
% - 'x' là pole (nghiệm mẫu)
% - vòng tròn là unit circle |z| = 1

title('Pole-Zero Plot of H(z)');
grid on;

% ================== ZPK FORM ==================
% Tạo transfer function (discrete-time, Ts = 1)
H = tf(num, den, -1);

% Chuyển sang zero-pole-gain form
H_zpk = zpk(H);

% Hiển thị kết quả
disp('Zero-Pole-Gain form:');
H_zpk

[r, p, k] = residue(num, den);