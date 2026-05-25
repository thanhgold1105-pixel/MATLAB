clc; clear; close all;

% Continuous-time axis (t in milliseconds, 0 to 2 ms)
t = 0:0.001:2;

% Original signal: x(t) = cos(2*pi*t) + cos(8*pi*t) + cos(12*pi*t)
%   Components at f = 1, 4, 6 kHz   =>   fmax = 6 kHz, Nyquist = 12 kHz
x = cos(2*pi*t) + cos(8*pi*t) + cos(12*pi*t);

%% ---------- Part a:  fs = 5 kHz  (below Nyquist) ----------
fs_a = 5;                  % samples / ms = kHz
Ts_a = 1/fs_a;
tn_a = 0:Ts_a:2;           % sample instants (ms)
xn_a = cos(2*pi*tn_a) + cos(8*pi*tn_a) + cos(12*pi*tn_a);

% Aliased signal:  xa(t) = 3*cos(2*pi*t)
xa_a = 3*cos(2*pi*t);

figure('Name','Problem 2a — f_s = 5 kHz')
plot(t, x,    'b',  'LineWidth', 1.5); hold on
plot(t, xa_a, 'r--','LineWidth', 1.5)
stem(tn_a, xn_a, 'k', 'filled')
xlabel('t (ms)'); ylabel('Amplitude')
title('Aliasing when f_s = 5 kHz   →   x_a(t) = 3 cos(2\pi t)')
legend('x(t)','x_a(t)','Samples x(nT_s)','Location','best')
grid on

%% ---------- Part b:  fs = 10 kHz  (still below Nyquist) ----------
fs_b = 10;                 % kHz
Ts_b = 1/fs_b;
tn_b = 0:Ts_b:2;
xn_b = cos(2*pi*tn_b) + cos(8*pi*tn_b) + cos(12*pi*tn_b);

% Aliased signal:  xa(t) = cos(2*pi*t) + 2*cos(8*pi*t)
xa_b = cos(2*pi*t) + 2*cos(8*pi*t);

figure('Name','Problem 2b — f_s = 10 kHz')
plot(t, x,    'b',  'LineWidth', 1.5); hold on
plot(t, xa_b, 'r--','LineWidth', 1.5)
stem(tn_b, xn_b, 'k', 'filled')
xlabel('t (ms)'); ylabel('Amplitude')
title('Aliasing when f_s = 10 kHz   →   x_a(t) = cos(2\pi t) + 2 cos(8\pi t)')
legend('x(t)','x_a(t)','Samples x(nT_s)','Location','best')
grid on