clc;
clear;
close all;

% Define parameters
T = 1;
alpha = 0:0.0001:1;
T_act = T .* alpha;
T_remain = (1 - alpha) .* T;
P_c = [70 80 90]; % in dBm
P_r = 0:1:100; % in dBm
P_c_value = 10.^(P_c ./ 10);
P_r_value = 10.^(P_r ./ 10);
sigma_cr = 1;
sigma_n = 1;
sigma_rr = 1;

% Initialize beta array with compatible dimensions
beta = zeros(length(P_r), length(P_c), length(alpha));

% Calculate beta for each combination
for i = 1:length(P_c)
    for j = 1:length(P_r)
        beta(j, i, :) = 1 ./ (1 + alpha .* T .* (sigma_cr^2 * P_c_value(i)) ./ (sigma_rr^2 * P_r_value(j) + sigma_n^2));
    end
end

% Calculate eta (average over alpha or use a specific value)
eta = zeros(length(P_r), length(P_c));
for i = 1:length(P_c)
    for j = 1:length(P_r)
        % Use the mean value of beta over alpha, or select a specific index if needed
        beta_mean = mean(squeeze(beta(j, i, :)));
        term1 = - (beta_mean * (1 - beta_mean) * sigma_cr^2 * P_c_value(i)) / ((sigma_rr^2 * P_r_value(j) - beta_mean * sigma_cr^2 * P_c_value(i)) * (2 * beta_mean - 1));
        term2 = (exp(sigma_n^2 / (beta_mean * sigma_cr^2 * P_c_value(i))) / log(2)) * expint((sigma_n^2) / (beta_mean * sigma_cr^2 * P_c_value(i)));
        term3 = (sigma_rr^2 * P_r_value(j) * (1 - beta_mean) * sigma_cr^2 * P_c_value(i)) / ((sigma_rr^2 * P_r_value(j) - beta_mean * sigma_cr^2 * P_c_value(i)) * (sigma_rr^2 * P_r_value(j) - (1 - beta_mean) * sigma_cr^2 * P_c_value(i)));
        term4 = (exp((sigma_n^2) / (sigma_rr^2 * P_r_value(j))) / log(2)) * expint((sigma_n^2) / (sigma_rr^2 * P_r_value(j)));
        term5 = ((1 - beta_mean)^2 * sigma_cr^2 * P_c_value(i)) / ((sigma_rr^2 * P_r_value(j) - (1 - beta_mean) * sigma_cr^2 * P_c_value(i)) * (2 * beta_mean - 1));
        term6 = (exp(sigma_n^2 / ((1 - beta_mean) * sigma_cr^2 * P_c_value(i))) / log(2)) * expint((sigma_n^2) / ((1 - beta_mean) * sigma_cr^2 * P_c_value(i)));
        eta(j,i) = T_remain(1) * (term1 * term2 + term3 * term4 + term5 * term6); % Using T_remain(1) as a representative value
    end
end

% Plotting
figure;
line_patterns = {':', '--', '-.'};
for i = 1:length(P_c)
    plot(P_r, eta(:, i), 'k', 'LineStyle', line_patterns{i}, 'LineWidth', 1.5, ...
        'DisplayName', sprintf('P_c = %d dBm', P_c(i)));
    hold on;
end
xlabel('Radar''s Transmit Power P_r (dBm)');
ylabel('Communication Throughput \eta');
title('Throughput \eta vs P_r for different P_c');
legend('show', 'Location', 'Best');
grid on;
hold off;
