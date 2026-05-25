clc; clear; close all;

% Initial parameter
T = 1;
sigma_n = 1;
sigma_rr = 1;
sigma_cr = 1;
P_c_dB = 10;
P_c = 10^(P_c_dB / 10);

% Define ranges for alpha
alpha_range = linspace(0, 1, 200);

% Radar transmit power levels (in dBW)
P_r_dB_values = [5, 10, 15];        
lineStyles = {':', '--', '-.'};     % Line styles for different powers
color = 'k';                        % Use black for all plots

% Prepare figure
figure; hold on;

% Loop over each P_r value
for j = 1:length(P_r_dB_values)
    P_r_dB = P_r_dB_values(j);
    P_r = 10^(P_r_dB / 10); % Convert dBW to linear scsale

    % Preallocate arrays
    eta_total = zeros(size(alpha_range));
    beta = zeros(size(alpha_range));

    % Loop over each alpha value
    for i = 1:length(alpha_range)
        alpha = alpha_range(i);

        % Beta calculations
        beta_first_part = sigma_cr^2 * P_c;
        beta_second_part = sigma_rr^2 * P_r + sigma_n^2;
        beta_third_part = alpha * T;
        beta_denominator = 1 + beta_third_part * (beta_first_part/beta_second_part);
        beta_i = 1/beta_denominator;
        beta(i) = beta_i;

        % Each eta part
        part_1 = (1-alpha)*T;

        part_2_numerator = -beta_i*(1-beta_i)*(sigma_cr^2)*P_c;
        part_2_denominator = ((sigma_rr^2)*P_r - beta_i*(sigma_cr^2)*P_c)*(2*beta_i - 1);

        part_3 = (sigma_n^2)/(beta_i*(sigma_cr^2)*P_c);

        part_4_numerator = (sigma_rr^2)*P_r*(1-beta_i)*(sigma_cr^2)*P_c;
        part_4_denominator = ((sigma_rr^2)*P_r - beta_i*(sigma_cr^2)*P_c)*((sigma_rr^2)*P_r - (1-beta_i)*(sigma_cr^2)*P_c);

        part_5 = (sigma_n^2)/((sigma_rr^2)*P_r);

        part_6_numerator = ((1-beta_i)^2)*(sigma_cr^2)*P_c;
        part_6_denominator = ((sigma_rr^2)*P_r - (1-beta_i)*(sigma_cr^2)*P_c)*(2*beta_i - 1);

        part_7 = (sigma_n^2)/((1-beta_i)*(sigma_cr^2)*P_c);

        % Each term part
        term_1 = part_2_numerator/part_2_denominator;
        term_2 = exp(part_3)/log(2);
        term_3 = expint(part_3);

        term_4 = part_4_numerator/part_4_denominator;
        term_5 = exp(part_5)/log(2);
        term_6 = expint(part_5);

        term_7 = part_6_numerator/part_6_denominator;
        term_8 = exp(part_7)/log(2);
        term_9 = expint(part_7);

        % Calculate eta
        eta_total(i) = part_1 * (term_1*term_2*term_3 + term_4*term_5*term_6 + term_7*term_8*term_9);

    end
    % Plotting
    plot(alpha_range, eta_total, 'LineStyle', lineStyles{j}, 'Color', color, 'LineWidth', 1.5);
    hold on;
end

xlabel('\alpha'); ylabel('\eta(\alpha)');
legend('P_r = 5 dBW', 'P_r = 10 dBW', 'P_r = 15 dBW');
grid on;
