clc; clear; close all;

% ================== PROBLEM 3 ==================
% H(z) = (z^2 + 1)/(z^2 - 1.39z + 1.21)
% Đây là hệ LTI rời rạc được biểu diễn trong miền Z

% ------------------ Khai báo hệ ------------------
% num: vector hệ số tử số theo lũy thừa giảm dần của z
% den: vector hệ số mẫu số theo lũy thừa giảm dần của z

num = [1 0 1];          
% tương ứng: z^2 + 0*z + 1
% => hệ có 2 zero (j và -j)

den = [1 -1.39 1.21];   
% tương ứng: z^2 - 1.39z + 1.21
% => hệ có 2 pole (...j và ...j)

% ================== SUBPLOT 1 ==================
% Mục tiêu: vẽ pole-zero plot trong mặt phẳng z

subplot(1,2,1);
% chia figure thành 1 hàng, 2 cột
% chọn vị trí số 1 (bên trái)

zplane(num, den);
% zplane:
% - Tính và vẽ các nghiệm của tử số (zeros) và mẫu số (poles)
% - vẽ vị trí zero (ký hiệu 'o')
% - vẽ vị trí pole (ký hiệu 'x')
% - đồng thời vẽ unit circle (|z| = 1) dùng để kiểm tra stability
% - Nếu tất cả poles nằm trong unit circle → hệ ổn định

title('Pole-Zero Plot');

grid on;

% ================== SUBPLOT 2 ==================
% Mục tiêu: tính và vẽ impulse response h[n]

subplot(1,2,2);
% chọn vị trí số 2 (bên phải)

[h, n] = impz(num, den, 80);
% impz:
% - tính impulse response của hệ
% - giả sử input x[n] = delta[n]
% - 80 (samples): số mẫu cần tính (n = 0 → 79)
%
% output:
% h: giá trị h[n]
% n: chỉ số thời gian (discrete-time)

stem(n, h, 'filled');
% stem:
% - vẽ tín hiệu rời rạc (discrete-time signal)
% - 'filled': tô đậm điểm cho dễ nhìn

title('Impulse Response (80 samples)');

xlabel('n');

ylabel('h[n]');

grid on;