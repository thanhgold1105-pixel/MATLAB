% Initial parameters
clc; clear; close all;

sigma_hc = 1;
sigma_n = 1;
sigma_gc = 1;
sigma_hr = 1;
sigma_gr = 1;
N = 500;
P_r_dB_values = linspace(0, 20, 100); % P_r range in dB from 0 to 30
R_value = 4; % Fixed R value

% Define ranges for alpha and delta
alpha_range = linspace(0, 1, 200); % Alpha range from 0 to 1
delta_range = linspace(0, 6, 500); % Delta range
B = 200000; % Bandwidth for radar mutual information
rho = 0.0001;

% Values of P_avg_dB to iterate over
P_avg_dB_values = [5 10 15];
lineStyles = {':', '--', '-.'}; % Line styles for each P_avg_dB value
fixed_throughput = 50; % Fixed throughput value

figure;
hold on;

for idx = 1:length(P_avg_dB_values)
    % Set P_avg for the current iteration
    P_avg_dB = P_avg_dB_values(idx);
    P_avg = 10^(P_avg_dB / 10);
    
    % Preallocate array to store maximum mutual information over Pr values
    max_information_over_P_r = zeros(1, length(P_r_dB_values));
    
    for pr_idx = 1:length(P_r_dB_values)
        % Convert Pr_dB to linear scale for current iteration
        P_r_dB = P_r_dB_values(pr_idx);
        P_r = 10^(P_r_dB / 10);

        % Recalculate eta_total_matrix and I_matrix for this Pr value
        eta_total_matrix = zeros(length(alpha_range), length(delta_range));
        I_matrix = zeros(length(alpha_range), length(delta_range));
        
        for i = 1:length(alpha_range)
            alpha = alpha_range(i);
            if alpha == 0 || alpha == 1
                eta_total_matrix(i, :) = 0;
            end
            for k = 1:length(delta_range)
                delta = delta_range(k);
                P_c_value = P_avg * exp(delta / sigma_hc);
                
                % Calculate beta, n_value, and remaining terms
                beta = 1 / (1 + (alpha * N * P_avg * sigma_hc) / (sigma_gc * P_r + sigma_n));
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

                part_7 = (a * exp(sigma_n / (beta * sigma_hc * P_c_value)) * (1 - beta)) / beta;

                % % Calculate epsilon, eta, epsilon_prime, and eta_prime
                % epsilon = 1 - (part_7 * (part_2 - part_3));
                % eta = n_remaining * R_value * (1 - epsilon) * exp(-delta / sigma_hc);

                epsilon_prime = 1 + part_1 * (part_2 - part_3) - part_4 * (part_5 - part_6);
                eta_prime = n_remaining * R_value * (1 - epsilon_prime) * exp(-delta / sigma_hc);

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
        
        % Calculate max_information for fixed throughput value
        indices = find(abs(eta_total_matrix - fixed_throughput) < 2);
        if ~isempty(indices)
            max_information_over_P_r(pr_idx) = max(I_matrix(indices));
        end
    end
    
    % Plot max_information_over_P_r versus P_r_dB_values for each P_avg_dB
    plot(P_r_dB_values, max_information_over_P_r, lineStyles{idx}, 'Color', 'k','LineWidth', 1.5);
end

% Customize plot
xlabel('$P_r$ (dBW)', 'Interpreter', 'latex');
ylabel('Maximum Radar Mutual Information $I_{\max}$', 'Interpreter', 'latex');
legend('$\bar{P} = 5$ dBW', '$\bar{P} = 10$ dBW', '$\bar{P} = 15$ dBW', 'Interpreter', 'latex', 'Location', 'Best');
grid on;
hold off;
