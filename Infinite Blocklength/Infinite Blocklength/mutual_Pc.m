clc;
clear;
close all;

% Define parameters
T = 1;
B = 200 * 10^3;
P_r = [40 50 60]; % in dBm
P_c = 0:1:100; % in dBm
P_c_value = 10.^(P_c ./ 10); 
P_r_value = 10.^(P_r ./ 10); 
sigma_cbs = 1;
sigma_n = 1;
sigma_rt = 1;
rho = 0.1;

% Precompute constants
ln2 = log(2);
sigma_cbs_sq = sigma_cbs^2;
sigma_n_sq = sigma_n^2;
sigma_rt_sq = sigma_rt^2;

% Initialize I_BS array
I_BS = zeros(length(P_c), length(P_r));

% Calculate I_BS for each P_c and P_r
for i = 1:length(P_c)
    for j = 1:length(P_r)
        denom_factor = (T * rho * P_c_value(i) * sigma_cbs_sq) / (sigma_rt_sq * P_r_value(j)) + 1;
        term1 = exp(sigma_n_sq / (rho * P_c_value(i) * sigma_cbs_sq)) * expint(sigma_n_sq / (rho * P_c_value(i) * sigma_cbs_sq));
        term2 = exp((T * sigma_n_sq) / (sigma_rt_sq * P_r_value(j))) * expint((T * sigma_n_sq) / (sigma_rt_sq * P_r_value(j)));
        I_BS(i,j) = ((B * T) / (ln2 * denom_factor)) * (term1 + term2);
    end
end

% Plot with patterns and black color
patterns = {':','--','-.'};
figure;
hold on;
for j = 1:length(P_r)
    plot(P_c, I_BS(:, j), 'k', 'LineStyle', patterns{j}, 'LineWidth', 2, 'DisplayName', sprintf('P_r = %d dBm', P_r(j)));
end
xlabel('Communication Power P_c (dBm)');
ylabel('Radar''s Mutual Information I_{BS}');
legend('show');
grid on;
hold off;
