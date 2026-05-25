clc; clear; close all;
%% ===== PROBLEM 4 =====
R = 1;          % Ohm
C = 0.1;        % Farad

%% ---- Part a: Frequency response của mạch gốc (RC Low-pass) ----
w = 0:0.01:100;                     % Tần số (rad/s)
H_a = 1 ./ (1 + 1j*w*R*C);         % H(jw) = 1/(1 + jwRC)

figure;
subplot(2,1,1);
plot(w, abs(H_a), 'b', 'LineWidth', 1.5);
title('Part a - Frequency Response (Low-pass RC): Magnitude');
xlabel('\omega (rad/s)');
ylabel('|H(j\omega)|');
grid on;

subplot(2,1,2);
plot(w, angle(H_a)*180/pi, 'r', 'LineWidth', 1.5);
title('Part a - Frequency Response (Low-pass RC): Phase');
xlabel('\omega (rad/s)');
ylabel('Phase (degrees)');
grid on;

%% ---- Part b: Đổi chỗ R và C → CR High-pass filter ----
% C nối tiếp, R song song với ngõ ra
% H(jw) = jwRC / (1 + jwRC)
H_b = (1j*w*R*C) ./ (1 + 1j*w*R*C);

figure;
subplot(2,1,1);
plot(w, abs(H_b), 'b', 'LineWidth', 1.5);
title('Part b - Frequency Response (High-pass CR): Magnitude');
xlabel('\omega (rad/s)');
ylabel('|H(j\omega)|');
grid on;

subplot(2,1,2);
plot(w, angle(H_b)*180/pi, 'r', 'LineWidth', 1.5);
title('Part b - Frequency Response (High-pass CR): Phase');
xlabel('\omega (rad/s)');
ylabel('Phase (degrees)');
grid on;

% --> Part b: Mạch trở thành High-pass filter (ngược với part a)

%% ---- Part c: Square wave → Low-pass RC (mạch part a) ----
fs = 2000;              % Sampling frequency (Hz)
f0 = 7;                 % Square wave frequency (Hz)
T  = 1/fs;              % Sampling period
t  = 0:T:1-T;           % Thời gian 1 giây

% Tạo tín hiệu vuông
Vi = square(2*pi*f0*t);

% Tính đáp ứng Vo = IFFT( FFT(Vi) * H(jw) )
N   = length(Vi);
Vi_fft = fft(Vi);

% Tần số tương ứng với FFT
f_axis = (0:N-1)*(fs/N);
w_axis = 2*pi*f_axis;

% Tính H tại các tần số FFT (dùng mạch part a)
H_c = 1 ./ (1 + 1j*w_axis*R*C);

% Nhân trong miền tần số → lọc
Vo_fft = Vi_fft .* H_c;

% Chuyển về miền thời gian
Vo_c = real(ifft(Vo_fft));

figure;
subplot(2,1,1);
plot(t, Vi, 'b', 'LineWidth', 1.2);
title('Part c - Input Vi: Square wave 7Hz');
xlabel('Time (s)'); ylabel('Amplitude');
xlim([0 0.5]); grid on;

subplot(2,1,2);
plot(t, Vo_c, 'r', 'LineWidth', 1.2);
title('Part c - Output Vo: Low-pass RC (mạch gốc)');
xlabel('Time (s)'); ylabel('Amplitude');
xlim([0 0.5]); grid on;

%% ---- Part d: Square wave → High-pass CR (mạch part b) ----
H_d = (1j*w_axis*R*C) ./ (1 + 1j*w_axis*R*C);

Vo_fft_d = Vi_fft .* H_d;
Vo_d = real(ifft(Vo_fft_d));

figure;
subplot(2,1,1);
plot(t, Vo_c, 'r', 'LineWidth', 1.2);
title('Part d - So sánh: Vo từ Low-pass (part c)');
xlabel('Time (s)'); ylabel('Amplitude');
xlim([0 0.5]); grid on;

subplot(2,1,2);
plot(t, Vo_d, 'm', 'LineWidth', 1.2);
title('Part d - Vo từ High-pass (part b)');
xlabel('Time (s)'); ylabel('Amplitude');
xlim([0 0.5]); grid on;