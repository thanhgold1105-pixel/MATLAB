clc; clear; close all;

% Initial parameters
sigma_rr = 1;
sigma_cr = 1;
sigma_n = 1;
P_c_dB = 10;                     % Communication power (dB)
P_c = 10^(P_c_dB / 10);          % Linear scale
P_r_dB = 10;                     % Radar power (dB)
P_r = 10^(P_r_dB / 10);          % Linear scale                         

% Define range for alpha
alpha_range = linspace(0, 1, 200);

% Communication transmit power levels (in dBW)
T_values = [0.5, 0.75, 1];
lineStyles = {':', '--', '-.'};     % Line styles for different powers
color = 'k';                        % Use black for all plots

% Prepare figure
figure; hold on;

for j = 1:length(T_values)
    T = T_values(j);

    % Preallocate arrays
    beta = zeros(size(alpha_range));
    xi_total = zeros(size(alpha_range));
    
    % Loop over each alpha value
    for i = 1:length(alpha_range)
        alpha = alpha_range(i);

        % Beta calculations
        beta_first_part = sigma_cr^2 * P_c;
        beta_second_part = (sigma_rr^2 * P_r) + sigma_n^2;
        beta_whole_part = beta_first_part/beta_second_part;
        beta_denominator = 1 + (alpha * T * beta_whole_part);
        beta_i = 1/beta_denominator;
        beta(i) = beta_i;

        % Radar detection calculation
        num1 = sigma_rr^2 * P_r;
        deno1 = (beta_i * sigma_cr^2 * P_c) - (sigma_rr^2 * P_r);
        num2 = sigma_rr^2 * P_r;
        deno2 = beta_i * sigma_cr^2 * P_c;

        func1 = num1/deno1;
        func2 = num2/deno2;
        func3= deno2/deno1;

        term1 = func2^(-func1);
        term2 = func2^(-func3);

        xi_total(i)= 1 - func1 * (term1 - term2);

    end
     % Plot each curve
     plot(alpha_range, xi_total, 'LineStyle', lineStyles{j}, 'Color', color, 'LineWidth', 1.5);
     hold on;
end
% Final plot settings
xlabel('\alpha');  ylabel('\xi');
legend('T = 0.5 s', 'T = 0.75 s', 'T c= 1 s');
grid on;