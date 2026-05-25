clc; clear; close all;

% ================== DEFINE SYSTEM ==================
% Hệ được cho dưới dạng frequency response:
% H(ω) = (0.1 + 0.1e^{-jω} + 0.18e^{-j2ω} + ... ) /
%        (1 - 1.5e^{-jω} + 2.2e^{-j2ω} - ...)

% Trong MATLAB, ta biểu diễn hệ bằng dạng H(z):
% với e^{-jωk} <-> z^{-k}

% num: hệ số tử số (b_k)
% den: hệ số mẫu số (a_k)

num = [0.1 0.1 0.18 0.18 0.09 0.09];
% tương ứng:
% 0.1 + 0.1z^{-1} + 0.18z^{-2} + 0.18z^{-3} + 0.09z^{-4} + 0.09z^{-5}
% => quyết định ZERO của hệ (frequency attenuation)

den = [1 -1.5 2.2 -1.5 0.8 0.18];
% tương ứng:
% 1 -1.5z^{-1} + 2.2z^{-2} -1.5z^{-3} + 0.8z^{-4} -0.18z^{-5}
% => quyết định POLE của hệ (stability & dynamics)

% ================== (a) FREQUENCY RESPONSE ==================
% Mục tiêu:
% - Tính H(e^{jω})
% - Vẽ magnitude (dB) và phase (rad)

[H, w] = freqz(num, den, 1024);
% freqz:
% - Tính frequency response của hệ
% - H: giá trị H(e^{jω})
% - w: vector tần số (0 → π rad/sample)
% - 1024: số điểm lấy mẫu (càng lớn → càng mịn)

figure;

% -------- Magnitude Response --------
subplot(2,1,1);
% chia figure thành 2 hàng, 1 cột, chọn plot trên

plot(w, 20*log10(abs(H)), 'LineWidth', 1.5);
% abs(H): biên độ |H(e^{jω})|
% log10 + nhân 20: chuyển sang đơn vị dB
% (dB = 20 log10 |H|)

title('Magnitude Response');
xlabel('\omega (rad/sample)');
ylabel('Magnitude (dB)');
grid on;
% grid giúp dễ quan sát các notch và peak

% -------- Phase Response --------
subplot(2,1,2);

plot(w, angle(H), 'LineWidth', 1.5);
% angle(H): pha của H(e^{jω}) (đơn vị rad)
% lưu ý: phase có thể bị wrap (nhảy từ π → -π)

title('Phase Response');
xlabel('\omega (rad/sample)');
ylabel('Phase (radians)');
grid on;

% ================== (b) IMPULSE RESPONSE ==================
% Mục tiêu:
% - Tính h[n] = inverse Z-transform của H(z)
% - h[n] là đáp ứng của hệ khi x[n] = δ[n]

[y, n_imp] = impz(num, den, 50);
% impz:
% - tự động chuyển H(z) → phương trình sai phân
% - giải đệ quy với input δ[n]
% - 50: số mẫu cần tính (n = 0 → 49)

figure;

stem(n_imp, h, 'LineWidth', 1.5);
% stem:
% - dùng cho tín hiệu rời rạc (discrete-time)
% - mỗi mẫu là một "cọc"

title('Impulse Response');
xlabel('n');
ylabel('h[n]');
grid on;

% ================== (c) STEP RESPONSE ==================
% Mục tiêu:
% - Tính đáp ứng của hệ với input x[n] = u[n] (step)
% - step response cho biết hành vi dài hạn của hệ

[s, n_step] = stepz(num, den, 50);
% stepz:
% - tương tự impz nhưng input là unit step
% - giúp quan sát steady-state behavior

figure;

stem(n_step, s, 'LineWidth', 1.5);

title('Step Response');
xlabel('n');
ylabel('s[n]');
grid on;

% ================== NHẬN XÉT DSP ==================
% - Nếu h[n] giảm dần → hệ stable
% - Nếu step response hội tụ → tồn tại steady-state
% - Magnitude response cho biết hệ lọc tần số nào
% - Phase response cho biết độ trễ pha của hệ