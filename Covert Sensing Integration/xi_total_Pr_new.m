clc; clear; close all;

% Parameters
sigma_sr = 1; sigma_sw = 1;
sigma_rw = 1; sigma_rs = 1;
sigma_rr = 1; sigma_ss = 1;
sigma_n = 1; epsilon = 0.05;

P_s_dB = 10;                   % fixed sender power
P_s = 10^(P_s_dB / 10);
beta = 0.5;                    % fixed SI suppression

alpha_range = linspace(0, 1, 200);
P_r_dB_values = [5, 15, 25];   % 3 curves for relay power
lineStyles = {':', '--', '-.'};
color = 'k';                   % all lines black (like sample figure)

figure; hold on;
xlabel('$\alpha$', 'Interpreter', 'latex');
ylabel('Warden detection error probability $\xi_{total}(\alpha)$', 'Interpreter', 'latex');
legend_entries = {};

% Loop over 3 P_r values
for p = 1:length(P_r_dB_values)
    P_r_dB = P_r_dB_values(p);
    P_r = 10^(P_r_dB / 10);

    % Compute constants Z and C
    Z = lambertw((sigma_n^2 / (beta * P_r * sigma_rr^2)) * exp((sigma_n^2 / (beta * P_r * sigma_rr^2)) - log(1 - epsilon))) - ( sigma_n^2/(beta * P_r * sigma_rr^2) );
    C = (sigma_rs^2 / (beta * P_s * sigma_ss^2)) * lambertw(((beta * P_s * sigma_ss^2) / (P_r * sigma_rs^2)) * exp(((beta * P_s * sigma_ss^2) / (P_r * sigma_rs^2)) - log(1 - epsilon)));

    % Compute ξ_total for all α
    xi_total_vals = zeros(1, length(alpha_range));
    for i = 1:length(alpha_range)
        alpha = alpha_range(i);
        
        % Calculate ξ_cs
        part_1_a = (alpha * P_s * sigma_sr^2 / sigma_n^2) * Z;
        part_1_b = - (Z * (1 - alpha) * sigma_sr^2) / (sigma_sw^2 * (1 + part_1_a));
        part_1_c = 1 + (P_r * sigma_rw^2 * sigma_sr^2) / (sigma_n^2 * sigma_sw^2) * (Z * (1 - alpha)) / (1 + part_1_a);

        xi_cS = 1 - exp(part_1_b) * (part_1_c)^(-1);

        % Calculate ξ_cr
        part_2_a = sigma_rw^2 / (sigma_rw + C * P_s * sigma_sw^2);
        part_2_b = - (C * sigma_n^2) / sigma_rw^2;

        xi_cR = 1 - part_2_a * exp(part_2_b);

        % Calculate ξ_cS|R
        numerator = sigma_n^2 * sigma_sr^2 * Z * (1 - alpha);
        denominator = sigma_sw^2 * (sigma_n^2 + alpha * P_s * sigma_sr^2 * Z);

        xi_cS_R = 1 - exp(-numerator / denominator);

        % Calculate ξ_total
        xi_total_vals(i) = xi_cS_R * (1 - xi_cR) + xi_cS * xi_cR;
    end

    % Plot for each P_r value
    plot(alpha_range, xi_total_vals, ...
        'LineWidth', 1.5, 'Color', color, 'LineStyle', lineStyles{p});
    legend_entries{end+1} = sprintf('$P_R = %d$ dBW', P_r_dB);
end

% Finalize plot
legend(legend_entries, 'Interpreter', 'latex', 'Location', 'best');
title('Warden detection error probability vs. $\alpha$', 'Interpreter', 'latex');
grid on;
hold off;