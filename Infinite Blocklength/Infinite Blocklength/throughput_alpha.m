clc;
clear;
close all;

% Parameters
T_values = [1, 2, 3];
patterns = {':','--','-.'};
alpha = 0:0.0001:1;
P_c = 80; % dBm
P_r = 80; % dBm
P_c_value = 10^(P_c/10);
P_r_value = 10^(P_r/10);
sigma_cr = 1;
sigma_n = 1;
sigma_rr = 1;

figure; hold on;
for idx = 1:length(T_values)
    T = T_values(idx);
    beta_values = 1 ./ (1 + alpha .* T .* (sigma_cr^2 * P_c_value) ./ (sigma_rr^2 * P_r_value + sigma_n^2));
    eta_values = zeros(size(alpha));
    for k = 1:length(alpha)
        beta_val = beta_values(k);
        term1 = - (beta_val * (1 - beta_val) * sigma_cr^2 * P_c_value) / ((sigma_rr^2 * P_r_value - beta_val * sigma_cr^2 * P_c_value) * (2 * beta_val - 1));
        term2 = (exp(sigma_n^2 / (beta_val * sigma_cr^2 * P_c_value)) / log(2)) * expint(sigma_n^2 / (beta_val * sigma_cr^2 * P_c_value));
        term3 = (sigma_rr^2 * P_r_value * (1 - beta_val) * sigma_cr^2 * P_c_value) / ((sigma_rr^2 * P_r_value - beta_val * sigma_cr^2 * P_c_value) * (sigma_rr^2 * P_r_value - (1 - beta_val) * sigma_cr^2 * P_c_value));
        term4 = (exp(sigma_n^2 / (sigma_rr^2 * P_r_value)) / log(2)) * expint(sigma_n^2 / (sigma_rr^2 * P_r_value));
        term5 = ((1 - beta_val)^2 * sigma_cr^2 * P_c_value) / ((sigma_rr^2 * P_r_value - (1 - beta_val) * sigma_cr^2 * P_c_value) * (2 * beta_val - 1));
        term6 = (exp(sigma_n^2 / ((1 - beta_val) * sigma_cr^2 * P_c_value)) / log(2)) * expint(sigma_n^2 / ((1 - beta_val) * sigma_cr^2 * P_c_value));
        eta_values(k) = (1 - alpha(k)) .* (term1 .* term2 + term3 .* term4 + term5 .* term6);
    end
    plot(alpha, eta_values, 'k', 'LineStyle', patterns{idx}, 'LineWidth', 1.5, 'DisplayName', ['T = ' num2str(T) ' s']);
end
xlabel('Pilot Coefficient \alpha');
ylabel('Communication Throughput \eta');
legend show;
grid on;