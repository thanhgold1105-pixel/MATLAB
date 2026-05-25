clc; clear; close all;

% Parameters and configurations
sigma_n = 1;
sigma_hs = 1;
sigma_ht = 1;
P_c_value = 10;
P_c = 10^(P_c_value / 10);
P_r_value = 10;
P_r = 10^(P_r_value / 10);

% Define range for rho
rho_range = linspace(0.01, 1, 200);  % Avoid zero to prevent divide-by-zero
B = 200000;                          % Bandwidth

% Time transmit values
T_values = [0.25, 0.5, 1];
lineStyles = {':', '--', '-.'};
color = 'k';

% Prepare figure
figure; hold on;

for j = 1:length(T_values)
    T = T_values(j);

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
legend('T = 0.25', 'T = 0.5', 'T = 1', 'Location', 'best');
title('Radar Mutual Information vs. $\rho$ for different $T$', 'Interpreter', 'latex');
