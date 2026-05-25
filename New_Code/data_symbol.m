clc; clear; close all;

% Initial parameters
sigma_hc = 1;
sigma_n = 1;
sigma_gc = 1;
sigma_hr = 1;
P_r_value = 10;
P_r = 10^(P_r_value / 10);

% Define ranges for alpha, delta, and N
alpha_range = linspace(0, 1, 100);  % Alpha range from 0 to 1
delta_range = linspace(0, 6, 1000);  % Delta range
N_range = linspace(200, 700, 100);    % N range for plotting
R_value = 4;                        % Fixed R value

% Different values of P_avg_dB to plot
P_avg_dB_values = [5 10 15];
lineStyles = {':', '--', '-.'};     % Line styles for each P_avg_dB value
color = 'k';                        % Set all plots to black color

% Initialize figure
figure;
hold on;

for p = 1:length(P_avg_dB_values)
    P_avg_dB = P_avg_dB_values(p);
    P_avg = 10^(P_avg_dB / 10);
    max_eta_total = zeros(1, length(N_range));  % Store max eta_total for each N

    % Loop over N_range
    for n_idx = 1:length(N_range)
        N = N_range(n_idx);

        if N == 0
            max_eta_total(n_idx) = 0;
        end
        
        % Initialize variable to store max eta over alpha after maximizing over delta
        eta_max_over_alpha = zeros(1, length(alpha_range)); 

        % Loop over alpha first
        for i = 1:length(alpha_range)
            alpha = alpha_range(i);

            % Initialize variable to store max eta over delta for this alpha
            max_eta_delta = 0;

            % Loop over delta and find max eta for this alpha
            for k = 1:length(delta_range)
                delta = delta_range(k);
                P_c_value = P_avg * exp(delta / sigma_hc);

                % Calculate beta, rho, n_value, and remaining terms
                beta = 1 / (1 + (alpha * N * P_avg * sigma_hc) / (sigma_gc*P_r + sigma_n));
                n_value = alpha * N;
                n_remaining = (1 - alpha) * N;
                rho = 0.0001;

                % % Calculate lambda and P_d
                % lambda = real(gammaincinv(1 - rho, n_value, 'lower'));  % Ensure lambda is real
                % P_d = real(1 - gammainc(sigma_n * lambda / (P_avg * sigma_hr + sigma_n), n_value, 'lower'));

                % Calculate constants a and b based on R_value
                a = (2 * pi * (2^(2 * R_value) - 1) / n_remaining)^(-1/2);
                b = 2^R_value - 1;

                % Calculate parts of eta and epsilon expressions with real constraints
                part_1 = real((a * exp(sigma_n / (beta * sigma_hc * P_c_value)) * (1 - beta) * sigma_hc * P_c_value) / (sigma_gc * P_r - beta * sigma_hc * P_c_value));
                part_2 = real(expint((sigma_n / ((1 - beta) * sigma_hc * P_c_value)) * (b - 1/(2*a) + (1 - beta)/beta)));
                part_3 = real(expint((sigma_n / ((1 - beta) * sigma_hc * P_c_value)) * (b + 1/(2*a) + (1 - beta)/beta)));

                part_4 = real((a * exp(sigma_n / (sigma_gc * P_r)) * (1 - beta) * sigma_hc * P_c_value) / (sigma_gc * P_r - beta * sigma_hc * P_c_value));
                part_5 = real(expint((sigma_n / ((1 - beta) * sigma_hc * P_c_value)) * (b - 1/(2*a) + ((1 - beta) * sigma_hc * P_c_value)/(sigma_gc * P_r))));
                part_6 = real(expint((sigma_n / ((1 - beta) * sigma_hc * P_c_value)) * (b + 1/(2*a) + ((1 - beta) * sigma_hc * P_c_value)/(sigma_gc * P_r))));

                part_7 = real((a * exp(sigma_n / (beta * sigma_hc * P_c_value)) * (1 - beta)) / beta);

                % % Calculate epsilon, eta, epsilon_prime, and eta_prime
                % epsilon = 1 - (part_7 * (part_2 - part_3));
                % eta = n_remaining * R_value * (1 - epsilon) * exp(-delta / sigma_hc);  

                epsilon_prime = 1 + part_1 * (part_2 - part_3) - part_4 * (part_5 - part_6);
                eta_prime = n_remaining * R_value * (1 - epsilon_prime) * exp(-delta / sigma_hc); 

                % Calculate eta_total including P_d for this alpha and delta
                eta_total_value = eta_prime;

                % Update max_eta_delta if this delta gives a higher value
                if eta_total_value > max_eta_delta
                    max_eta_delta = eta_total_value;
                else
                    break;
                end
            end

            % Store max eta over delta for this alpha
            eta_max_over_alpha(i) = max_eta_delta;
        end

        % Find max eta over alpha for this N
        max_eta_total(n_idx) = max(eta_max_over_alpha);
    end

    % Plot max eta_total versus N for current P_avg_dB
    plot(N_range, max_eta_total, lineStyles{p}, 'Color', color, 'LineWidth', 1.5);
end

% Finalize plot
xlabel('Number of symbol ($N$)', 'Interpreter', 'latex');
ylabel('Communication Throughput $\eta_c(\alpha, \delta)$', 'Interpreter', 'latex');
legend('$\bar{P} = 5$ dBW', '$\bar{P} = 10$ dBW', '$\bar{P} = 15$ dBW', 'Interpreter', 'latex', 'Location', 'Best');
grid on;
hold off;
