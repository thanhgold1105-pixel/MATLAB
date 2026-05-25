clc; clear; close all;

% Initial parameters
sigma_hc = 1;
sigma_n = 1;
sigma_gc = 1;
sigma_hr = 1;
N = 500;
P_r_value = 10;
P_r = 10^(P_r_value / 10);

% Define ranges for alpha and delta
alpha_range = linspace(0, 1, 200);  % Alpha range from 0 to 1
delta_range = linspace(0, 6, 1000); % Delta range
R_value = 4; % Fixed R value

% Different values of P_avg_dB to plot
P_avg_dB_values = [5 10 15];
lineStyles = {':', '--', '-.'};  % Line styles for each P_avg_dB value
color = 'k'; % Set all plots to black color

% Initialize plot
figure;
hold on;
xlabel('$\delta$', 'Interpreter', 'latex');
ylabel('Communication Throughput $\eta_c(\alpha,\delta)$', 'Interpreter', 'latex');
legend_entries = {};

% Loop over different P_avg_dB values
for p = 1:length(P_avg_dB_values)
    P_avg_dB = P_avg_dB_values(p);
    P_avg = 10^(P_avg_dB / 10);
    max_eta_total_per_delta = zeros(1, length(delta_range));

    % Loop over delta_range to calculate the maximum eta_total for each delta
    for k = 1:length(delta_range)
        delta = delta_range(k);
        eta_total_values_for_alpha = zeros(1, length(alpha_range));

        for i = 1:length(alpha_range)
            alpha = alpha_range(i);
            

            % Calculate beta, rho, n_value, and remaining terms
            beta = 1 / (1 + (alpha * N * P_avg * sigma_hc) / (sigma_gc*P_r + sigma_n));
            n_value = alpha * N;
            n_remaining = (1 - alpha) * N;
            rho = 0.0001;
            P_c_value = P_avg * exp(delta / ((1-beta)*sigma_hc));

            % Check and constrain values to avoid division by zero or unrealistic results
            if n_remaining <= 0 || beta <= 0 || P_c_value <= 0 || sigma_gc * P_r <= beta * sigma_hc * P_c_value
                eta_total_values_for_alpha(i) = NaN;
                continue;
            end

            % % Calculate lambda and P_d
            % lambda = gammaincinv(1 - rho, n_value, 'lower');  
            % P_d = 1 - gammainc(sigma_n * lambda / (P_avg * sigma_hr + sigma_n), n_value, 'lower');

            % Calculate constants a and b based on R_value
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
            % eta = n_remaining * R_value * (1 - epsilon) * exp(-delta / sigma_hc);  % Ensure eta is non-negative

            epsilon_prime = 1 + part_1 * (part_2 - part_3) - part_4 * (part_5 - part_6);
            eta_prime = n_remaining * R_value * (1 - epsilon_prime) * exp(-delta / ((1-beta)*sigma_hc));  % Ensure eta_prime is non-negative
            % 
            % % Calculate eta_total including P_d
            % eta_total = P_d * eta + (1 - P_d) * eta_prime;

            % % Store eta_total for the current alpha
            % eta_total_values_for_alpha(i) = eta_total;
            eta_total_values_for_alpha(i) = eta_prime;
        end

        % Find the maximum eta_total for the current delta across all alpha values
        max_eta_total_per_delta(k) = max(eta_total_values_for_alpha, [], 'omitnan');
    end

    % Plot max eta_total versus delta for the current P_avg_dB with line style and black color
    plot(delta_range, max_eta_total_per_delta, 'LineWidth', 1.5, 'Color', color, 'LineStyle', lineStyles{p});
    legend_entries{end+1} = ['$\bar{P} = ' num2str(P_avg_dB) '$ dBW'];
end

legend(legend_entries, 'Location', 'Best', 'Interpreter', 'latex');
grid on;
hold off;
