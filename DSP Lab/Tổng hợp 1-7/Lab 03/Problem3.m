clc; clear; close all;

%% Load audio
[x, Fs] = audioread('Sound.wav');
x = x(:,1)';   % lấy 1 kênh

%% Tạo impulse response h[n]
delay = 0.2;                  % 0.2 seconds
D = round(delay * Fs);        % số mẫu delay

h = zeros(1, D+1);
h(1) = 1;                     % tín hiệu gốc
h(D+1) = 0.8;                 % echo

%% Convolution (dùng hàm tự viết hoặc conv)
y = conv(x, h);

%% Trục thời gian
t_x = (0:length(x)-1)/Fs;
t_y = (0:length(y)-1)/Fs;

%% Plot
figure;

subplot(2,1,1);
plot(t_x, x);
title('Original Signal');
xlabel('Time (s)');

subplot(2,1,2);
plot(t_y, y);
title('Echo Signal');
xlabel('Time (s)');

%% Play audio
disp('Playing original signal...');
sound(x, Fs);
pause(length(x)/Fs + 1);

disp('Playing echo signal...');
sound(y, Fs);