clc; clear all; close all;

%% Problem 4
% ECG Signal Filtering using FIR Low-pass Filter

% Number of samples
N = 500;

% Sampling frequency (Hz)
fs = 500;

%% Original ECG signal

% Generate ECG signal using ecg() function
x = ecg(N);

%% Add random Gaussian noise

% y(t) = x(t) + 0.1*randn([1 N])
y = x + 0.1*randn(1,N);

%% Design FIR low-pass filter

% Filter specifications:
% - FIR low-pass filter
% - Filter order = 10
% - Cutoff frequency = 15 Hz
% - Sampling frequency = 500 Hz

lpFilt = designfilt('lowpassfir', ...
                    'FilterOrder',10, ...
                    'CutoffFrequency',15, ...
                    'SampleRate',fs);

%% Filter the noisy ECG signal

y_filtered = filter(lpFilt,y);

%% Time axis

t = (0:N-1)/fs;

%% Plot original noisy signal and filtered signal

figure;

plot(t,y,'b');
hold on;

plot(t,y_filtered,'r','LineWidth',1.5);

xlabel('Time (s)');
ylabel('Amplitude');

title('ECG Signal Filtering');

legend('Noisy ECG Signal','Filtered ECG Signal');

grid on;