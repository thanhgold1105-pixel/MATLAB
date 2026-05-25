% Initial parameters
clc; clear; close all;

sigma_hc = 1;
sigma_n = 1;
sigma_gc = 1;
sigma_hr = 1;
sigma_gr = 1;
N = 500;
P_r_value = 10;
P_r = 10^(P_r_value / 10);
R_value = 4;  % Fixed R value

% Define ranges for alpha and delta
alpha_range = linspace(0, 1, 1000);  % Alpha range from 0 to 1
delta_range = linspace(0, 6, 1000);  % Delta range
delta = 0;
B = 200000;  % Bandwidth for radar mutual information
% rho = 0.0001;

% Values of P_avg_dB to iterate over
P_avg_dB_values = [5 10 15];
lineStyles = {':', '--', '-.'};  % Line styles for each P_avg_dB value
fixed_throughput_values = linspace(0, 210, 1000);  % Range for fixed throughput values

figure;
hold on;

for idx = 1:length(P_avg_dB_values)
    % Set P_avg for the current iteration
    P_avg_dB = P_avg_dB_values(idx);
    P_avg = 10^(P_avg_dB / 10);

    % Preallocate arrays for storing results over alpha and delta
    eta_total_matrix = zeros(length(alpha_range), length(delta_range));

    I_matrix = zeros(length(alpha_range), length(delta_range));


    % Calculate eta_total and I_main for each alpha and delta
    for i = 1:length(alpha_range)
        alpha = alpha_range(i);

        % Set eta_total and I_main to 0 if alpha is 0 or 1
        if alpha == 0 || alpha == 1
            eta_total_matrix(i, :) = 0;
            continue;
        end

        for k = 1:length(delta_range)
            delta = delta_range(k);
            P_c_value = P_avg * exp(delta / sigma_hc);

            % Calculate beta, n_value, and remaining terms
            beta = 1 / (1 + (alpha * N * P_avg * sigma_hc) / (sigma_gc*P_r + sigma_n));
            
            n_value = alpha * N;
            n_remaining = (1 - alpha) * N;

            % % Calculate lambda and P_d
            % lambda = gammaincinv(1 - rho, n_value, 'lower');  
            % P_d = 1 - gammainc(sigma_n * lambda / (P_avg * sigma_hr + sigma_n), n_value, 'lower');

            % Communication Throughput (eta)
            a = (2 * pi * (2^(2 * R_value) - 1) / n_remaining)^(-1/2);
            b = 2^R_value - 1;

            % Calculate parts of eta and epsilon expressions
            part_1 = (a * exp(sigma_n / (beta * sigma_hc * P_c_value)) * (1 - beta) * sigma_hc * P_c_value) / (sigma_gc * P_r - beta * sigma_hc * P_c_value);
            part_2 = expint((sigma_n / ((1 - beta) * sigma_hc * P_c_value)) * (b - 1/(2*a) + (1 - beta)/beta));
            part_3 = expint((sigma_n / ((1 - beta) * sigma_hc * P_c_value)) * (b + 1/(2*a) + (1 - beta)/beta));

            part_4 = (a * exp(sigma_n / (sigma_gc * P_r)) * (1 - beta) * sigma_hc * P_c_value) / (sigma_gc * P_r - beta * sigma_hc * P_c_value);
            part_5 = expint((sigma_n / ((1 - beta) * sigma_hc * P_c_value)) * (b - 1/(2*a) + ((1 - beta) * sigma_hc * P_c_value)/(sigma_gc * P_r)));
            part_6 = expint((sigma_n / ((1 - beta) * sigma_hc * P_c_value)) * (b + 1/(2*a) + ((1 - beta) * sigma_hc * P_c_value)/(sigma_gc * P_r)));

            % part_7 = (a * exp(sigma_n / (beta * sigma_hc * P_c_value)) * (1 - beta)) / beta;

            % % Calculate epsilon, eta, epsilon_prime, and eta_prime
            % epsilon = 1 - (part_7 * (part_2 - part_3));
            % eta = n_remaining * R_value * (1 - epsilon) * exp(-delta / sigma_hc);  % Ensure eta is non-negative
            % 
            epsilon_prime = 1 + part_1 * (part_2 - part_3) - part_4 * (part_5 - part_6);
            eta_prime = n_remaining * R_value * (1 - epsilon_prime) * exp(-delta / sigma_hc);  % Ensure eta_prime is non-negative

            % eta_total = P_d * eta + (1 - P_d) * eta_prime;
            eta_total_matrix(i, k) = eta_prime;

            P_eff = alpha * P_avg + (1 - alpha) * P_c_value;

            % Components of mutual information
            part_11 = (B * N) / (log(2) * (((N * alpha * P_avg * sigma_hr) / (sigma_gr * P_r)) + 1));
            part_21 = exp(sigma_n / (alpha * P_avg * sigma_hr)) * expint(sigma_n / (alpha * P_avg * sigma_hr));
            part_31 = exp((N * sigma_n) / (sigma_gr * P_r)) * expint((N * sigma_n) / (sigma_gr * P_r));

            part_41 = (B * N) / (log(2) * (((N * P_eff * sigma_hr) / (sigma_gr * P_r)) + 1));
            part_51 = exp(sigma_n / (P_eff * sigma_hr)) * expint(sigma_n / (P_eff * sigma_hr));
            part_61 = exp((N * sigma_n) / (sigma_gr * P_r)) * expint((N * sigma_n) / (sigma_gr * P_r));

            I_R = part_11 * (part_21 + part_31); 
            I_R_prime = part_41 * (part_51 + part_61);

            % Mutual information components
            I_1 = I_R * (1 - exp(-delta / sigma_hc));
            I_2 = I_R_prime * exp(-delta / sigma_hc);

            I_total = I_1 + I_2;
            I_matrix(i, k) = I_total;
        end
    end

    % Initialize array to store maximum mutual information for the current P_avg_dB
    max_information = zeros(1, length(fixed_throughput_values));

    % Find the maximum mutual information for each fixed communication throughput value
    for j = 1:length(fixed_throughput_values)
        fixed_throughput = fixed_throughput_values(j);
        % Find the indices where the throughput is close to the fixed value
        indices = find(abs(eta_total_matrix - fixed_throughput) < 1);
        if ~isempty(indices)
            % Get the maximum mutual information among those indices
            max_information(j) = max(I_matrix(indices));
        end
    end

    % Plotting max_information versus fixed_throughput_values for current P_avg_dB
    plot(fixed_throughput_values, max_information, lineStyles{idx}, 'Color', 'k', 'LineWidth', 1.5);
end

% Customize plot
hold on;

for idx2 = 1:length(P_avg_dB_values)
    % Set P_avg for the current iteration
    P_avg_dB2 = P_avg_dB_values(idx2);
    P_avg2 = 10^(P_avg_dB2 / 10);

    eta_total_matrix2 = zeros(length(alpha_range), 1);
    I_matrix2 = zeros(length(alpha_range), 1);

    % Calculate eta_total and I_main for each alpha and delta
    for i = 1:length(alpha_range)
        alpha = alpha_range(i);

        % Set eta_total and I_main to 0 if alpha is 0 or 1
        if alpha == 0 || alpha == 1
            eta_total_matrix2(i, :) = 0;
            continue;
        end

            % Calculate beta, n_value, and remaining terms
            beta2 = 1 / (1 + (alpha * N * P_avg2 * sigma_hc) / (sigma_n));
            n_value = alpha * N;
            n_remaining = (1 - alpha) * N;

            % Communication Throughput (eta)
            a = (2 * pi * (2^(2 * R_value) - 1) / n_remaining)^(-1/2);
            b = 2^R_value - 1;

            % Calculate parts of eta and epsilon expressions
            part_01 = (a * exp(sigma_n / (beta2 * sigma_hc * P_avg2)) * (1 - beta2) * sigma_hc * P_avg2) / (sigma_gc * P_r - beta2 * sigma_hc * P_avg2);
            part_02 = expint((sigma_n / ((1 - beta2) * sigma_hc * P_avg2)) * (b - 1/(2*a) + (1 - beta2)/beta2));
            part_03 = expint((sigma_n / ((1 - beta2) * sigma_hc * P_avg2)) * (b + 1/(2*a) + (1 - beta2)/beta2));

            part_04 = (a * exp(sigma_n / (sigma_gc * P_r)) * (1 - beta2) * sigma_hc * P_avg2) / (sigma_gc * P_r - beta2 * sigma_hc * P_avg2);
            part_05 = expint((sigma_n / ((1 - beta2) * sigma_hc * P_avg2)) * (b - 1/(2*a) + ((1 - beta2) * sigma_hc * P_avg2)/(sigma_gc * P_r)));
            part_06 = expint((sigma_n / ((1 - beta2) * sigma_hc * P_avg2)) * (b + 1/(2*a) + ((1 - beta2) * sigma_hc * P_avg2)/(sigma_gc * P_r)));

            epsilon_prime2 = 1 + part_01 * (part_02 - part_03) - part_04 * (part_05 - part_06);
            eta_prime2 = n_remaining * R_value * (1 - epsilon_prime2);  % Ensure eta_prime is non-negative

            % eta_total = P_d * eta + (1 - P_d) * eta_prime;
            eta_total_matrix2(i, :) = eta_prime2;

            % Components of mutual information
            part_40 = (B * n_remaining) / (log(2) * (((n_remaining * P_avg2 * sigma_hr) / (sigma_gr * P_r)) + 1));
            part_50 = exp(sigma_n / (P_avg2 * sigma_hr)) * expint(sigma_n / (P_avg2 * sigma_hr));
            part_60 = exp((n_remaining * sigma_n) / (sigma_gr * P_r)) * expint((n_remaining * sigma_n) / (sigma_gr * P_r));

            % I_R = part_10 * (part_20 + part_30); 
            I_R_prime2 = part_40 * (part_50 + part_60);

            % Mutual information components
            % I_1 = I_R * (1 - exp(-delta / sigma_hc));
            I_22 = I_R_prime2;

            I_total = I_22;
            I_matrix2(i, :) = I_total;
        
    end

    % Initialize array to store maximum mutual information for the current P_avg_dB
    max_information2 = zeros(1, length(fixed_throughput_values));

    % Find the maximum mutual information for each fixed communication throughput value
    for j = 1:length(fixed_throughput_values)
        fixed_throughput2 = fixed_throughput_values(j);
        % Find the indices where the throughput is close to the fixed value
        indices2 = find(abs(eta_total_matrix2 - fixed_throughput2) < 1);
        if ~isempty(indices2)
            % Get the maximum mutual information among those indices
            max_information2(j) = max(I_matrix2(indices2));
        end
    end

    % Plotting max_information versus fixed_throughput_values for current P_avg_dB
    plot(fixed_throughput_values, max_information2, lineStyles{idx2}, 'Color', 'r', 'LineWidth', 1.5);
end

% Customize plot
xlabel('Fixed Communication Throughput $\eta_0$', 'Interpreter', 'latex');
ylabel('Maximum Radar Mutual Information $I_{\max}$', 'Interpreter', 'latex');
grid on;

% Update the legend to include "benchmark scheme"
legend({'$\bar{P} = 5$ dBW', '$\bar{P} = 10$ dBW', '$\bar{P} = 15$ dBW', 'Benchmark scheme'}, ...
    'Interpreter', 'latex', 'Location', 'Best');

