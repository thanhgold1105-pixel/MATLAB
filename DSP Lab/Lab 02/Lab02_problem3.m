clc; clear; close all;

R = input('Enter R: ');
B = input('Enter B: ');

t = 0:0.001:1;
x = (R/2)*cos(2*pi*t);

y = quantized_example(x, R, B);

figure;
plot(t, x, 'k', 'LineWidth', 1.5); hold on;
stairs(t, y, 'r', 'LineWidth', 1.5);

legend('Input x(t)', 'Quantized y');
title('Quantization Example');
xlabel('Time');
ylabel('Amplitude');
grid on;