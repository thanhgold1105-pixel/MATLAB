clc; clear; close all;

% Initial parameters
sigma_rr = 1;
sigma_cr = 1;
sigma_n = 1;
T = 1;                           % Time duration (e.g., 1 second)4
P_c_dB = 10;                     % Communication power (dB)
P_c = 10^(P_c_dB / 10);          % Linear scale

% Define range for alpha
alpha_range = linspace(0, 1, 200);

% Radar power levels (in dBW)
P_r_dB_values = [10, 25, 20];
lineStyles = {':', '--', '-.'};     % Line styles
color = 'k';       

% Prepare figure
figure; hold on;

% Loop over each radar power level
for j = 1:length(P_r_dB_values)
    P_r_dB = P_r_dB_values(j);
    P_r = 10^(P_r_dB / 10);  % Convert dBW to linear scale

    % Preallocate arrays
    beta = zeros(size(alpha_range));
    eta_total = zeros(size(alpha_range));

    
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

        % Each eta part
        part_1 = (1-alpha) * T;

        part_2_numerator = -beta_i * (1 - beta_i) * sigma_cr^2 * P_c;
        part_2_denominator = (sigma_rr^2 * P_r - beta_i * sigma_cr^2 * P_c) * (2 * beta_i - 1) ;
        part_2 = part_2_numerator/part_2_denominator;
        part_3 = (sigma_n^2) / (beta_i * sigma_cr^2 * P_c);
        part_3_exp = exp(part_3)/log(2);
        part_3_expint = expint(part_3);

        term_1 = part_2 * part_3_exp  * part_3_expint;

        part_4_numerator = sigma_rr^2 * P_r * (1-beta_i) * sigma_cr^2 * P_c;
        part_4_denominator = (sigma_rr^2 * P_r - beta_i * sigma_cr^2 * P_c) * (sigma_rr^2 * P_r - (1-beta_i) * sigma_cr^2 * P_c);
        part_4 = part_4_numerator/part_4_denominator;
        part_5 = (sigma_n^2) / (sigma_rr^2 * P_r);
        part_5_exp = exp(part_5)/log(2);
        part_5_expint = expint(part_5);
        
        term_2 = part_4 * part_5_exp * part_5_expint;

        part_6_numerator = (1-beta_i)^2 * sigma_cr^2 * P_c;
        part_6_denominator = (sigma_rr^2 * P_r - (1-beta_i) * sigma_cr^2 * P_c) * (2*beta_i - 1);
        part_6 = part_6_numerator/part_6_denominator;
        part_7 = (sigma_n^2) / ((1-beta_i) * sigma_cr^2 * P_c);
        part_7_exp = exp(part_7)/log(2);
        part_7_expint = expint(part_7);

        term_3 = part_6 * part_7_exp * part_7_expint;

        % Calculate eta
        eta_total(i) = part_1 * (term_1 + term_2 + term_3);

    end 
    % Plotting
    plot(alpha_range, eta_total, 'LineStyle', lineStyles{j}, 'Color', color, 'LineWidth', 1.5);
    hold on;

end

xlabel('\alpha'); ylabel('\eta');
legend('P_r = 10 dB', 'P_r = 15 dB', 'P_r = 25 dB');
grid on;