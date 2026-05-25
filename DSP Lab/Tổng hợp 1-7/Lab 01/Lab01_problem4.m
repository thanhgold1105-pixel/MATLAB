clc; clear; close all;

%% Part a
% Input 4 component frequencies
freq1 = input('Enter first frequency f1: ');
freq2 = input('Enter second frequency f2: ');
freq3 = input('Enter third frequency f3: ');
freq4 = input('Enter fourth frequency f4: ');

% Continuous time axis
t = 0:0.001:5;

% Continuous time signal
x_a = 2.5*cos(2*pi*freq1*t) ...
    - 1.5*sin(2*pi*freq2*t) ...
    + cos(2*pi*freq3*t) ...
    + 0.5*cos(2*pi*freq4*t);

% Plot figure 
plot(t,x_a,'LineWidth',1.5) 
grid on 
xlabel('Time (t)') 
ylabel('Amplitude') 
title('Continuous-Time Signal x_a(t)')

%% Part b

% Find maximum frequency
fmax = max([freq1 freq2 freq3 freq4]);

% Sampling frequency
fs = 5*fmax;

% Sampling period
Ts = 1/fs;

% Sampled time axis
t_s = 0:Ts:5;

% Sampled signal
x_n = 2.5*cos(2*pi*freq1*t_s) ...
    - 1.5*sin(2*pi*freq2*t_s) ...
    + cos(2*pi*freq3*t_s) ...
    + 0.5*cos(2*pi*freq4*t_s);

% Reconstructed signal
x_rec = interp1(t_s, x_n, t, 'linear');

figure

% 1. Continuous signal
subplot(3,1,1)
plot(t,x_a,'LineWidth',1.5)
grid on
xlabel('Time (t)')
ylabel('Amplitude')
title('Original Continuous Signal x_a(t)')

% 2. Sampled discrete signal
subplot(3,1,2)
stem(t_s,x_n,'filled')
grid on
xlabel('Time (t)')
ylabel('Amplitude')
title('Sampled Discrete Signal x[n]')

% 3. Reconstruction + sampled
subplot(3,1,3)
plot(t,x_rec,'LineWidth',1.5)
hold on
stem(t_s,x_n,'filled')
grid on
xlabel('Time (t)')
ylabel('Amplitude')
title('Reconstructed Signal with Sampled Points')
legend('Reconstructed x_r(t)','Sampled x[n]')

%% Part c

% Sampling frequency (below Nyquist)
fs_c = 0.5*fmax;

% Sampling period
Ts_c = 1/fs_c;

% Sampled time axis
t_sc = 0:Ts_c:5;

% Sampled signal
x_nc = 2.5*cos(2*pi*freq1*t_sc) ...
     - 1.5*sin(2*pi*freq2*t_sc) ...
     + cos(2*pi*freq3*t_sc) ...
     + 0.5*cos(2*pi*freq4*t_sc);

% Reconstructed signal
x_rec_c = interp1(t_sc,x_nc,t,'linear');

figure

% 1 Original continuous signal
subplot(4,1,1)
plot(t,x_a,'LineWidth',1.5)
grid on
xlabel('Time (t)')
ylabel('Amplitude')
title('Original Continuous Signal x_a(t)')

% 2 Sampled discrete signal
subplot(4,1,2)
stem(t_sc,x_nc,'filled')
grid on
xlabel('Time (t)')
ylabel('Amplitude')
title('Sampled Discrete Signal x[n] (fs = 0.5 fmax)')

% 3 Sampled signal over original signal
subplot(4,1,3)
plot(t,x_a,'LineWidth',1.5)
hold on
stem(t_sc,x_nc,'filled')
grid on
xlabel('Time (t)')
ylabel('Amplitude')
title('Sampled Signal Superimposed on Original Signal')
legend('x_a(t)','x[n]')

% 4 Sampled signal over reconstructed signal
subplot(4,1,4)
plot(t,x_rec_c,'LineWidth',1.5)
hold on
stem(t_sc,x_nc,'filled')
grid on
xlabel('Time (t)')
ylabel('Amplitude')
title('Sampled Signal Over Reconstructed Signal')
legend('Reconstructed x_r(t)','x[n]')