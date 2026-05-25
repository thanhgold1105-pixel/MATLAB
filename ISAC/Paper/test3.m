clc; clear; close all;

% Parameters
sigma_ss = 1;   
sigma_sr = 1;
sigma_rs = 1;
sigma_rr = 1;   
sigma_tr = 1;
sigma_sw = 1;
sigma_rw = 1;

sigma_n = 1;

epsilon = 0.6;
beta = 0.01;
alpha = 0.1;

theta = 0.5;   % FIX theta

Pr_dB_list = [10, 20, 30];   % 3 trường hợp jammer
Ps_dB_range = 0:1:40;

lineStyles = {':','--','-'};
color = 'k';

figure; hold on; grid on;

for i = 1:length(Pr_dB_list)

    Pr = 10^(Pr_dB_list(i)/10);
    xi = zeros(size(Ps_dB_range));

    for j = 1:length(Ps_dB_range)

        Ps = 10^(Ps_dB_range(j)/10);

        % Compute Z and B
        Z = compute_Z(sigma_sr, sigma_rr, sigma_tr, sigma_n, epsilon, beta, theta, Pr, Ps);
        B = compute_B(Ps, sigma_ss, sigma_n, epsilon, beta);

        % ===== xi =====
        term_1 = exp( - ( (1 - alpha) * Z * sigma_n^2 ) / ( Ps * sigma_sw^2 * (1 + alpha * Z) ) );

        term_2 = (sigma_sw^2 * Ps * (1 + alpha * Z)) / ...
                 (sigma_sw^2 * Ps * (1 + alpha * Z) + (1 - alpha) * Z * Pr * sigma_rw^2);

        term_3 = 1 - exp( - (sigma_rs^2 * B) / (sigma_rw^2) ) * ...
                    ( 1 + (Ps * sigma_rs^2 * B * sigma_sw^2) / (sigma_n^2 * sigma_rw^2) )^(-1);

        term_4 = exp( - (sigma_rs^2 * B) / sigma_rw^2 ) / ...
                 ( 1 + (Ps * sigma_rs^2 * B * sigma_sw^2) / (sigma_n^2 * sigma_rw^2) );

        xi(j) = 1 - term_1 * (term_2 * term_3 + term_4);
    end

    plot(Ps_dB_range, xi, ...
        'LineStyle', lineStyles{i}, ...
        'Color', color, ...
        'LineWidth', 1.5);
end

xlabel('P_S (dB)');
ylabel('\xi');
legend(arrayfun(@(x) sprintf('P_R = %d dB', x), Pr_dB_list, 'UniformOutput', false));
title('Detection error probability vs P_S for different P_R');