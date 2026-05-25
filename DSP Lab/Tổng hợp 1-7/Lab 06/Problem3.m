% Problem 3: DTFT và DFT của x[n] = 5*cos(2*pi*n/3), 0 <= n <= 19
clc; clear; close all;

%% --- Tín hiệu ---
n = 0:19;
x = 5 * cos(2*pi*n/3);

%% --- DTFT ---
% w liên tục từ 0 đến 2*pi
w = 0:0.001:2*pi;

% Tính DTFT: X(w) = sum( x[n] * e^(-jwn) )
DTFT = zeros(1, length(w));
for i = 1:length(w)
    DTFT(i) = sum(x .* exp(-1j * w(i) * n));
end

%% --- DFT ---
N = length(x);          % N = 20
Xk = fft(x);            % Tính DFT bằng FFT
k = 0:N-1;
wk = 2*pi*k/N;          % Tần số rời rạc: wk = 2*pi*k/N

%% --- Vẽ Magnitude ---
figure;
subplot(2,1,1);
plot(w, abs(DTFT), 'b-', 'LineWidth', 1.5);      % DTFT: đường liên tục
hold on;
stem(wk, abs(Xk), 'r', 'filled', 'LineWidth', 1.5); % DFT: rời rạc
hold off;
title('Magnitude: DTFT vs DFT của x[n] = 5cos(2\pin/3)');
xlabel('\omega (rad)');
ylabel('Magnitude');
legend('DTFT', 'DFT');
xlim([0, 2*pi]);
grid on;

%% --- Vẽ Phase ---
subplot(2,1,2);
plot(w, angle(DTFT), 'b-', 'LineWidth', 1.5);
hold on;
stem(wk, angle(Xk), 'r', 'filled', 'LineWidth', 1.5);
hold off;
title('Phase: DTFT vs DFT của x[n] = 5cos(2\pin/3)');
xlabel('\omega (rad)');
ylabel('Phase (rad)');
legend('DTFT', 'DFT');
xlim([0, 2*pi]);
grid on;