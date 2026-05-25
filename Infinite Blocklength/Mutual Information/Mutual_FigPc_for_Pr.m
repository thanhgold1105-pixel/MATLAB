clc; clear all; close all;

% Parameters and configurations
T = 1;
sigma_n = 1;
sigma_hs = 1;
sigma_ht = 1;
P_c_value = 10;
P_c = 10^(P_c_value / 10);  % Radar power in linear scale

% Define range for rho
rho_range = linspace(0.01, 1, 200);  % Avoid zero to prevent divide-by-zero
B = 200000;                          % Bandwidth

% Communication transmit power levels (in dBW)
P_r_dB_values = [5, 10, 15];
lineStyles = {':', '--', '-.'};     % Line styles for different powers
color = 'k';                         % Use black for all plots

% Prepare figure
figure; hold on;

for j = 1:length(P_r_dB_values)
    P_r_dB = P_r_dB_values(j);
    P_r = 10^(P_r_dB / 10);  % Convert dBW to linear scale

    % Preallocate MI array
    MI_total = zeros(size(rho_range));

    for i = 1:length(rho_range)
        rho = rho_range(i);

        % Intermediate calculations
        part_1_denominator = log(2) * (((T * rho * P_c * sigma_hs^2) / (sigma_ht^2 * P_r)) + 1);
        part_2_3 = (sigma_n^2) / (rho * P_c * sigma_hs^2);
        part_4_5 = (T * sigma_n^2) / (sigma_ht^2 * P_r);

        % Each term
        term_1 = B * T / part_1_denominator;
        term_2 = exp(part_2_3);
        term_3 = expint(part_2_3);
        term_4 = exp(part_4_5);
        term_5 = expint(part_4_5);

        % MI
        MI_total(i) = term_1 * (term_2 * term_3 + term_4 * term_5);
    end

    % Plot each curve
    plot(rho_range, MI_total, lineStyles{j}, 'Color', color, 'LineWidth', 1.5);
end

xlabel('$\rho$', 'Interpreter', 'latex');
ylabel('Radar Mutual Information $MI(\rho)$', 'Interpreter', 'latex');
grid on;
legend('P_r = 5 dBW', 'P_r = 10 dBW', 'P_r = 15 dBW', 'Location', 'best');
title('Radar Mutual Information vs. $\rho$', 'Interpreter', 'latex');