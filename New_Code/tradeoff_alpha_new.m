clc; clear; close all;

% Parameters and configurations
sigma_hc = 1;
sigma_n = 1;
sigma_gc = 1;
sigma_hr = 1;
sigma_gr = 1; 
N = 500;
P_r_value = 10;
P_r = 10^(P_r_value / 10);
P_avg_dB = 15; 
P_avg = 10^(P_avg_dB / 10);

% Define ranges for alpha and delta
alpha_range = linspace(0, 1, 200);
delta_range = linspace(0, 6, 1000); % Varying delta
R_value = 4; % Fixed R value
B = 200000; % Bandwidth for radar mutual information
rho = 0.0001;

% Initialize arrays to store max values for each alpha
max_eta_total_per_alpha = zeros(1, length(alpha_range));

% Loop over each alpha value
for i = 1:length(alpha_range)
    alpha = alpha_range(i);

    % Set max_eta_total to 0 if alpha is 0
    if alpha == 0
        max_eta_total_per_alpha(i) = 0;
    else
        eta_total_values_for_delta = zeros(1, length(delta_range));

        % Loop over each delta value to calculate eta_total
        for k = 1:length(delta_range)
            delta = delta_range(k);
            P_c_value = P_avg * exp(delta / sigma_hc);

            % Calculate beta, rho, n_value, and remaining terms
            beta = 1 / (1 + (alpha * N * P_avg * sigma_hc) / (sigma_gc * P_r + sigma_n));
            n_remaining = (1 - alpha) * N;

            % Constants for eta calculation
            a = (2 * pi * (2^(2 * R_value) - 1) / n_remaining)^(-1/2);
            b = 2^R_value - 1;

            % Calculate parts of eta and epsilon expressions
            part_1 = (a * exp(sigma_n / (beta * sigma_hc * P_c_value)) * (1 - beta) * sigma_hc * P_c_value) / (sigma_gc * P_r - beta * sigma_hc * P_c_value);
            part_2 = expint((sigma_n / ((1 - beta) * sigma_hc * P_c_value)) * (b - 1/(2*a) + (1 - beta)/beta));
            part_3 = expint((sigma_n / ((1 - beta) * sigma_hc * P_c_value)) * (b + 1/(2*a) + (1 - beta)/beta));

            part_4 = (a * exp(sigma_n / (sigma_gc * P_r)) * (1 - beta) * sigma_hc * P_c_value) / (sigma_gc * P_r - beta * sigma_hc * P_c_value);
            part_5 = expint((sigma_n / ((1 - beta) * sigma_hc * P_c_value)) * (b - 1/(2*a) + ((1 - beta) * sigma_hc * P_c_value)/(sigma_gc * P_r)));
            part_6 = expint((sigma_n / ((1 - beta) * sigma_hc * P_c_value)) * (b + 1/(2*a) + ((1 - beta) * sigma_hc * P_c_value)/(sigma_gc * P_r)));

            epsilon_prime = 1 + part_1 * (part_2 - part_3) - part_4 * (part_5 - part_6);
            eta_prime = n_remaining * R_value * (1 - epsilon_prime) * exp(-delta / sigma_hc);  
            eta_total_values_for_delta(k) = eta_prime;
        end

        % Find the maximum eta_total for this alpha across all delta values
        max_eta_total_per_alpha(i) = max(eta_total_values_for_delta, [], 'omitnan');
    end
end

% Calculate radar mutual information (I_main) for alpha range
max_I_main_per_alpha = zeros(1, length(alpha_range));

for p = 1:length(alpha_range)
    alpha_value = alpha_range(p);
    I_total = zeros(length(delta_range), 1);

    for j = 1:length(delta_range)
        delta_value = delta_range(j);
        P_c = P_avg * exp(delta_value / sigma_hc);

        P_eff = alpha_value * P_avg + (1 - alpha_value) * P_c;

        % Components of mutual information
        part_11 = (B * N) / (log(2) * (((N * alpha_value * P_avg * sigma_hr) / (sigma_gr * P_r)) + 1));
        part_21 = exp(sigma_n / (alpha_value * P_avg * sigma_hr)) * expint(sigma_n / (alpha_value * P_avg * sigma_hr));
        part_31 = exp((N * sigma_n) / (sigma_gr * P_r)) * expint((N * sigma_n) / (sigma_gr * P_r));

        part_41 = (B * N) / (log(2) * (((N * P_eff * sigma_hr) / (sigma_gr * P_r)) + 1));
        part_51 = exp(sigma_n / (P_eff * sigma_hr)) * expint(sigma_n / (P_eff * sigma_hr));
        part_61 = exp((N * sigma_n) / (sigma_gr * P_r)) * expint((N * sigma_n) / (sigma_gr * P_r));

        I_R = part_11 * (part_21 + part_31); 
        I_R_prime = part_41 * (part_51 + part_61);

        % Mutual information components
        I_1 = I_R * (1 - exp(-delta_value / sigma_hc));
        I_2 = I_R_prime * exp(-delta_value / sigma_hc);

        I_total(j) = I_1 + I_2;
    end

    % Find the maximum mutual information for this alpha value across all delta values
    max_I_main_per_alpha(p) = max(I_total);
end

% Plotting the trade-off between max_eta_total_per_alpha and max_I_main_per_alpha versus alpha
figure;
yyaxis left
plot(alpha_range, real(max_eta_total_per_alpha), 'b-.', 'LineWidth', 1.5);
ylabel('Communication Throughput $\eta_c(\alpha, \delta)$', 'Interpreter', 'latex');

yyaxis right
plot(alpha_range, real(max_I_main_per_alpha), 'r-.', 'LineWidth', 1.5);
ylabel('Radar Mutual Information $I(\alpha, \delta)$', 'Interpreter', 'latex');

xlabel('$\alpha$', 'Interpreter', 'latex');
grid on;
legend({'$\eta_c(\alpha, \delta)$', '$I(\alpha, \delta)$'}, 'Interpreter', 'latex', 'Location', 'Best');
