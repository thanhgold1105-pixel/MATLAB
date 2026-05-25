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
delta_range = linspace(0, 6, 1000);
R_value = 4; % Fixed R value
B = 200000; % Bandwidth for radar mutual information
rho = 0.0001;

% Calculate max communication throughput (eta) for each delta
max_eta_total_per_delta = zeros(1, length(delta_range));

for k = 1:length(delta_range)
    delta = delta_range(k);
    eta_total_values_for_alpha = zeros(1, length(alpha_range));

    for i = 1:length(alpha_range)
        alpha = alpha_range(i);
        

        % Calculate beta, rho, n_value, and remaining terms
        beta = 1 / (1 + (alpha * N * P_avg * sigma_hc) / (sigma_gc*P_r + sigma_n));
        n_value = alpha * N;
        n_remaining = (1 - alpha) * N;
        P_c_value = P_avg * exp(delta / ((1-beta)*sigma_hc));

        % % Calculate lambda and P_d
        % lambda = gammaincinv(1 - rho, n_value, 'lower');  
        % P_d = 1 - gammainc(sigma_n * lambda / (P_avg * sigma_hr + sigma_n), n_value, 'lower');

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
        eta_prime = n_remaining * R_value * (1 - epsilon_prime) * exp(-delta / ((1-beta)*sigma_hc));  % Ensure eta_prime is non-negative

        % % Calculate eta_total including P_d
        % eta_total = P_d * eta + (1 - P_d) * eta_prime;

        % Store eta_total for the current alpha
        eta_total_values_for_alpha(i) = eta_prime;
    end

    % Find the maximum eta_total for the current delta across all alpha values
    max_eta_total_per_delta(k) = max(eta_total_values_for_alpha, [], 'omitnan');
end

% Calculate radar mutual information (I_main) for delta range
max_I_main = zeros(1, length(delta_range));

for j = 1:length(delta_range)
    delta_value = delta_range(j);
    I_total = zeros(length(alpha_range), 1);
    P_c = P_avg * exp(delta_value / sigma_hc);

    for p = 1:length(alpha_range)
        alpha_value = alpha_range(p);

        P_eff = alpha_value * P_avg + (1-alpha_value)*P_c;

        % Components of mutual information
        part_11 = (B*N) / (log(2) * (((N*alpha_value*P_avg*sigma_hr) / (sigma_gr*P_r)) + 1));
        part_21 = exp(sigma_n / (alpha_value*P_avg*sigma_hr)) * expint(sigma_n / (alpha_value*P_avg*sigma_hr));
        part_31 = exp((N*sigma_n) / (sigma_gr*P_r)) * expint((N*sigma_n) / (sigma_gr*P_r));

        part_41 = (B*N) / (log(2) * (((N*P_eff*sigma_hr) / (sigma_gr*P_r)) + 1));
        part_51 = exp(sigma_n / (P_eff*sigma_hr)) * expint(sigma_n / (P_eff*sigma_hr));
        part_61 = exp((N*sigma_n) / (sigma_gr*P_r)) * expint((N*sigma_n) / (sigma_gr*P_r));

        I_R = part_11 * (part_21 + part_31); 
        I_R_prime = part_41 * (part_51 + part_61);

        % Mutual information components
        I_1 = I_R * (1 - exp(-delta_value / ((1-beta)*sigma_hc)));
        I_2 = I_R_prime * exp(-delta_value / ((1-beta)*sigma_hc));

        I_total(p) = I_1 + I_2;
    end

    % Find the maximum mutual information for this delta value
    max_I_main(j) = max(I_total);
end

% Plotting
figure;
yyaxis left
h1 = plot(delta_range, max_eta_total_per_delta, 'b-.', 'LineWidth', 1.5);
ylabel('Communication Throughput $\eta_c(\alpha, \delta)$', 'Interpreter', 'latex');
hold on;
plot(delta_range(1), max_eta_total_per_delta(1), 'kx', 'MarkerSize', 10, 'LineWidth', 1.5);

yyaxis right
h2 = plot(delta_range, max_I_main, 'r-.', 'LineWidth', 1.5);
ylabel('Radar Mutual Information $I(\alpha, \delta)$', 'Interpreter', 'latex');
hold on;
plot(delta_range(1), max_I_main(1), 'kx', 'MarkerSize', 10, 'LineWidth', 1.5);

xlabel('$\delta$', 'Interpreter', 'latex');
grid on;
legend([h1, h2], {'$\eta_c(\alpha, \delta)$', '$I(\alpha, \delta)$'}, ...
       'Interpreter', 'latex', 'Location', 'Best');
