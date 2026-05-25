clc; clear; close all;

%% Part a
% Define parameters
f_s = 5000;
T_s = 1/f_s;
t = 0:1e-6:2e-3;

% Original Signal
x = cos(2*pi*1000*t) + cos(2*pi*4000*t) + cos(2*pi*6000*t);

sound(x,f_s)

% Alias signal
x_a = 3*cos(2*pi*1000*t);

% Sample points
n = 0:floor(2e-3/T_s);
ts = n*T_s;

xs = cos(2*pi*1000*ts) + cos(2*pi*4000*ts) + cos(2*pi*6000*ts);

% Plot
figure

plot(t*1000,x,'b','LineWidth',1.5)
hold on

plot(t*1000,x_a,'r--','LineWidth',1.5)

stem(ts*1000,xs,'k','filled')

grid on
xlabel('Time (ms)')
ylabel('Amplitude')

legend('x(t)','x_a(t)','Samples x(nT_s)')

title('Aliasing Demonstration')

%% Part b
% Define parameters
f_s = 10000;
T_s = 1/f_s;
t = 0:1e-6:2e-3;

% Signal function
x = cos(2*pi*1000*t) + cos(2*pi*4000*t) + cos(2*pi*6000*t);

% Alias signal  
x_a = cos(2*pi*1000*t) + 2*cos(2*pi*4000*t);

% Sample points
n = 0:floor(2e-3/T_s);
ts = n*T_s;

xs = cos(2*pi*1000*ts) + cos(2*pi*4000*ts) + cos(2*pi*6000*ts);

% Plot
figure

plot(t*1000,x,'b','LineWidth',1.5)
hold on
plot(t*1000,x_a,'r--','LineWidth',1.5)
stem(ts*1000,xs,'k','filled')

grid on
xlabel('Time (ms)')
ylabel('Amplitude')

legend('x(t)','x_a(t)','Samples x(nT_s)')
title('Aliasing Demonstration (f_s = 10kHz)')