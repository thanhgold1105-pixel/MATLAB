clc;
clear;
close all;

% Parameters
T = 1;
alpha = 0:0.001:1;                      % pilot power coefficient
Pr_dB = 0:1:100;                        % radar transmit power (dBm)
Pc_dB = [40 50 60];                    % communication power (dBm)
sigma_cr = 1;
sigma_n = 1;
sigma_rr = 1;

patterns = {'-', '--', ':'};           % Line styles

% Pre-allocate storage
P_MD = zeros(length(Pc_dB), length(Pr_dB), length(alpha));
eta_max = zeros(length(Pc_dB), length(Pr_dB));  % Max throughput per Pc, Pr
fixed_throughput = 15;

figure; hold on;

for idx = 1:length(Pc_dB)
    Pc = Pc_dB(idx);
    Pc_val = 10^(Pc/10);  % linear

    % Move this outside the inner loop — one full vector per Pc value
    detection_over_P_r = zeros(1, length(Pr_dB));

    for i = 1:length(Pr_dB)
        Pr = Pr_dB(i);
        Pr_val = 10^(Pr/10);  % linear
        eta_alpha = zeros(size(alpha));

        for k = 1:length(alpha)
            a = alpha(k);
            beta = 1 / (1 + a * T * (sigma_cr^2 * Pc_val) / (sigma_rr^2 * Pr_val + sigma_n^2));

            % Skip invalid beta
            if beta <= 0 || beta >= 1 || (2 * beta - 1) == 0 || ...
               (sigma_rr^2 * Pr_val - beta * sigma_cr^2 * Pc_val) == 0 || ...
               (sigma_rr^2 * Pr_val - (1 - beta) * sigma_cr^2 * Pc_val) == 0
                eta_alpha(k) = NaN;
                P_MD(idx, i, k) = NaN;
                continue;
            end

            % Compute throughput terms
            term1 = - (beta * (1 - beta) * sigma_cr^2 * Pc_val) / ...
                    ((sigma_rr^2 * Pr_val - beta * sigma_cr^2 * Pc_val) * (2 * beta - 1));
            term2 = (exp(sigma_n^2 / (beta * sigma_cr^2 * Pc_val)) / log(2)) * ...
                    expint(sigma_n^2 / (beta * sigma_cr^2 * Pc_val));
            term3 = (sigma_rr^2 * Pr_val * (1 - beta) * sigma_cr^2 * Pc_val) / ...
                    ((sigma_rr^2 * Pr_val - beta * sigma_cr^2 * Pc_val) * ...
                     (sigma_rr^2 * Pr_val - (1 - beta) * sigma_cr^2 * Pc_val));
            term4 = (exp(sigma_n^2 / (sigma_rr^2 * Pr_val)) / log(2)) * ...
                    expint(sigma_n^2 / (sigma_rr^2 * Pr_val));
            term5 = ((1 - beta)^2 * sigma_cr^2 * Pc_val) / ...
                    ((sigma_rr^2 * Pr_val - (1 - beta) * sigma_cr^2 * Pc_val) * (2 * beta - 1));
            term6 = (exp(sigma_n^2 / ((1 - beta) * sigma_cr^2 * Pc_val)) / log(2)) * ...
                    expint(sigma_n^2 / ((1 - beta) * sigma_cr^2 * Pc_val));

            eta_alpha(k) = (1 - a) * T * (term1 * term2 + term3 * term4 + term5 * term6);

            % Compute P_MD
            a_md = Pr_val * sigma_rr;
            b_md = Pc_val * sigma_cr * beta;
            if a_md ~= b_md && (a_md - b_md) ~= 0 && b_md > 0 && a_md > 0
                epsilon = (b_md / a_md)^(b_md / (a_md - b_md));
            else
                epsilon = 1;
            end
            P_MD(idx, i, k) = 1 - epsilon;
        end

        % Store max throughput for current Pr
        eta_max(idx, i) = max(real(eta_alpha));

        % Evaluate max P_MD (for given throughput condition)
        P_MD_max = squeeze(max(P_MD(idx, :, :), [], 2));  % 1 x Pr vector

        indices = find(abs(eta_max(idx, :) - fixed_throughput) < 1);
        if ~isempty(indices)
            detection_over_P_r(i) = max(P_MD_max(indices));
        else
            detection_over_P_r(i) = NaN;
        end
    end

    % Plot: detection error vs Pr
    plot(Pr_dB, detection_over_P_r, 'k', ...
         'LineStyle', patterns{idx}, ...
         'LineWidth', 1.5, ...
         'DisplayName', ['P_c = ' num2str(Pc) ' dB']);
end

xlabel('Radar Transmit Power P_r (dBm)');
ylabel('Max Communication Throughput \eta');
legend('show', 'Location', 'best');
grid on;
title('Throughput vs P_r for Different P_c (optimized over \alpha)');
