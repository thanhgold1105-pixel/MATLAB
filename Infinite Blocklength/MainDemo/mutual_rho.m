clc;
clear;
close all;

% Parameters
T = 1;
B = 200 * 10^3;
P_c = 30; % Fixed in dBm
P_r_values = [50 60 70]; % Variable values
rho_values = 0:0.001:1;
P_c_value = 10^(P_c / 10);
sigma_cbs = 1;
sigma_n = 1;
sigma_rt = 1;
ln2 = log(2);
sigma_cbs_sq = sigma_cbs^2;
sigma_n_sq = sigma_n^2;
sigma_rt_sq = sigma_rt^2;
patterns = {':','--','-.'};

figure;
hold on;
for k = 1:length(P_r_values)
    P_r_value = 10^(P_r_values(k) / 10);
    I_BS = zeros(1, length(rho_values));
    for j = 1:length(rho_values)
        rho = rho_values(j);
        denom_factor = (T * rho * P_c_value * sigma_cbs_sq) / (sigma_rt_sq * P_r_value) + 1;
        term1 = exp(sigma_n_sq / (rho * P_c_value * sigma_cbs_sq)) * expint(sigma_n_sq / (rho * P_c_value * sigma_cbs_sq));
        term2 = exp((T * sigma_n_sq) / (sigma_rt_sq * P_r_value)) * expint((T * sigma_n_sq) / (sigma_rt_sq * P_r_value));
        I_BS(j) = ((B * T) / (ln2 * denom_factor)) * (term1 + term2);
    end
    plot(rho_values, I_BS, 'k', 'LineStyle', patterns{k}, 'LineWidth', 2, 'DisplayName', ['P_r = ' num2str(P_r_values(k)) ' dBm']);
end
xlabel("rho");
ylabel("Radar's Mutual Information I_{BS}");
title("I_{BS} vs \rho for P_c = 60 dBm");
legend("show");
grid on;
hold off;
