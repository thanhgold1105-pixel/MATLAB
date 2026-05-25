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
alpha_range = linspace(0, 1, 200);  % Alpha range from 0 to 1
delta_range = linspace(0, 6, 1000);  % Delta range
B = 200000;  % Bandwidth for radar mutual information
rho = 0.0001;

% Values of P_avg_dB to iterate over
P_avg_dB_values = [5 10 15];
lineStyles = {':', '--', '-.'};  % Line styles for each P_avg_dB value
fixed_throughput_values = linspace(0, 200, 1000);  % Range for fixed throughput values

figure; % Create a figure for plotting
hold on;

for idx = 1:length(P_avg_dB_values)
    % Set P_avg for the current iteration
    P_avg_dB = P_avg_dB_values(idx);
    P_avg = 10^(P_avg_dB / 10);
    
    % Preallocate arrays for storing results over alpha and delta
    eta_total_matrix = zeros(length(alpha_range), length(delta_range));
    
    % Calculate eta_total for each alpha and delta
    for i = 1:length(alpha_range)
        alpha = alpha_range(i);

        % Set eta_total to 0 if alpha is 0 or 1
        if alpha == 0 || alpha == 1
            eta_total_matrix(i, :) = 0;
            continue;
        end

        for k = 1:length(delta_range)
            delta = delta_range(k);
            P_c_value = P_avg * exp(delta / sigma_hc);

            % Calculate beta, n_value, and remaining terms
            beta = 1 / (1 + (alpha * N * P_avg * sigma_hc) / (sigma_gc * P_r + sigma_n));
            n_remaining = (1 - alpha) * N;

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
    
            part_7 = (a * exp(sigma_n / (beta * sigma_hc * P_c_value)) * (1 - beta)) / beta;
    
            % Calculate eta_prime
            epsilon_prime = 1 + part_1 * (part_2 - part_3) - part_4 * (part_5 - part_6);
            eta_prime = max(0, n_remaining * R_value * (1 - epsilon_prime) * exp(-delta / sigma_hc));  % Ensure eta_prime is non-negative

            % Store eta_prime in eta_total_matrix
            eta_total_matrix(i, k) = eta_prime;
        end
    end

    % Calculate the maximum eta_total across all delta values for each alpha
    max_eta_total = max(eta_total_matrix, [], 2);

    % Calculate eta_loss for each fixed_throughput_value
    eta_loss = zeros(length(fixed_throughput_values), 1);
    for j = 1:length(fixed_throughput_values)
        eta_loss(j) = max(max_eta_total) - fixed_throughput_values(j);
    end
    eta_loss(eta_loss < 0) = 0; % Ensure eta_loss is non-negative

    % Plot eta_loss versus fixed_throughput_values
    plot(fixed_throughput_values, eta_loss, lineStyles{idx}, 'Color', 'k', 'LineWidth', 1.5);
end

% Add labels and legend
xlabel('Fixed Communication Throughput $\eta_0$', 'Interpreter', 'latex');
ylabel('Loss Communication Throughput $\eta_{c,loss}(\alpha,\delta)$', 'Interpreter', 'latex');
legend('$\bar{P} = 5$ dBW', '$\bar{P} = 10$ dBW', '$\bar{P} = 15$ dBW', 'Interpreter', 'latex', 'Location', 'Best');
grid on;
hold off;
