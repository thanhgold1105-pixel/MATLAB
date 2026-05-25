clc; clear; close all;

%% Input the four component frequencies (used for all parts)
f1 = input('Enter f1 (Hz): ');
f2 = input('Enter f2 (Hz): ');
f3 = input('Enter f3 (Hz): ');
f4 = input('Enter f4 (Hz): ');

fmax = max([f1 f2 f3 f4]);
fmin = min([f1 f2 f3 f4]);

% Adaptive continuous-time axis:
%   - long enough to see 2 periods of the slowest component AND
%     at least ~8 sample periods of the slowest sampling (part c)
% fs_c = 0.5*fmax  =>  Ts_c = 2/fmax  =>  8*Ts_c = 16/fmax
t_end = max(2/fmin, 16/fmax);
dt    = 1/(50*fmax);          % 50 points / period of fastest component
t     = 0:dt:t_end;

% xa(t) as an anonymous function so we can reuse it
xa_func = @(tt) 2.5*cos(2*pi*f1*tt) - 1.5*sin(2*pi*f2*tt) ...
              + cos(2*pi*f3*tt)     + 0.5*cos(2*pi*f4*tt);

xa = xa_func(t);

%% ---------- Part a: plot xa(t) ----------
figure('Name','Problem 4a — x_a(t)')
plot(t, xa, 'b', 'LineWidth', 1.5)
title('Continuous Signal x_a(t)')
xlabel('t (s)'); ylabel('Amplitude'); grid on

%% ---------- Part b: f_s = 5 f_max  (above Nyquist) ----------
fs_b = 5*fmax;
Ts_b = 1/fs_b;
tn_b = 0:Ts_b:t_end;          % sample instants
xn_b = xa_func(tn_b);          % sample values

figure('Name','Problem 4b — f_s = 5 f_{max}')
subplot(3,1,1)
plot(t, xa, 'b', 'LineWidth', 1.5)
title(sprintf('Original signal x_a(t),  f_{max} = %.3g Hz', fmax))
xlabel('t (s)'); ylabel('x_a(t)'); grid on

subplot(3,1,2)
stem(tn_b, xn_b, 'r', 'filled')
title(sprintf('Sampled signal x[n] at f_s = 5 f_{max} = %.3g Hz', fs_b))
xlabel('t (s)'); ylabel('x[n]'); grid on

subplot(3,1,3)
plot(t, xa, 'b', 'LineWidth', 1.5); hold on
stem(tn_b, xn_b, 'r', 'filled')
title('x[n] superimposed on the reconstructed signal')
xlabel('t (s)'); ylabel('Amplitude'); grid on
legend('x_a(t)  (≈ reconstructed)','x[n]','Location','best')

%% ---------- Part c: f_s = 0.5 f_max  (below Nyquist — aliasing) ----------
fs_c = 0.5*fmax;
Ts_c = 1/fs_c;
tn_c = 0:Ts_c:t_end;
xn_c = xa_func(tn_c);

% Reconstructed (aliased) signal: replace f1=f2=f3=f4 = f_s
xr = 2.5*cos(2*pi*fs_c*t) - 1.5*sin(2*pi*fs_c*t) ...
   +     cos(2*pi*fs_c*t) + 0.5*cos(2*pi*fs_c*t);

figure('Name','Problem 4c — f_s = 0.5 f_{max}')
subplot(4,1,1)
plot(t, xa, 'b', 'LineWidth', 1.5)
title('Original signal x_a(t)')
xlabel('t (s)'); ylabel('x_a(t)'); grid on

subplot(4,1,2)
stem(tn_c, xn_c, 'r', 'filled')
title(sprintf('Sampled signal x[n] at f_s = 0.5 f_{max} = %.3g Hz', fs_c))
xlabel('t (s)'); ylabel('x[n]'); grid on

subplot(4,1,3)
plot(t, xa, 'b', 'LineWidth', 1.5); hold on
stem(tn_c, xn_c, 'r', 'filled')
title('x[n] superimposed on the original signal x_a(t)')
xlabel('t (s)'); ylabel('Amplitude'); grid on
legend('x_a(t)','x[n]','Location','best')

subplot(4,1,4)
plot(t, xr, 'g', 'LineWidth', 1.5); hold on
stem(tn_c, xn_c, 'r', 'filled')
title('x[n] superimposed on the reconstructed signal (f_1=f_2=f_3=f_4=f_s)')
xlabel('t (s)'); ylabel('Amplitude'); grid on
legend('x_r(t)','x[n]','Location','best')