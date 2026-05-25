clc; clear; close all;

% Initial parameter
T = 1;
sigma_n = 1;
sigma_rr = 1;
sigma_cr = 1;
alpha = 0.5;

% Defined radar power range
P_r_range = linspace(-20, 50, 200);

% Radar power levels (in dBW)
P_c_dB_values = [10, 15, 20];
lineStyles = {':', '--', '-.'};     % Line styles
color = 'k';

% Prepare figure
figure; hold on;

% Loop over each radar power level
for j = 1:length(P_c_dB_values)
    P_c_dB = P_c_dB_values(j);
    P_c = 10^(P_c_dB / 10);  % Convert dBW to linear scale

    % Preallocate arrays
    beta = zeros(size(P_r_range));
    eta_total = zeros(size(P_r_range));

    for i = 1:length(P_r_range)
        P_r_dB = P_r_range(i);
        P_r = 10^(P_r_dB / 10); % Convert dBW to linear scale

        % Beta calculations
        beta_first_part = sigma_cr^2 * P_c;
        beta_second_part = (sigma_rr^2 * P_r) + sigma_n^2;
        beta_whole_part = beta_first_part/beta_second_part;
        beta_denominator = 1 + (alpha * T * beta_whole_part);
        beta_i = 1/beta_denominator;
        beta(i) = beta_i;

        % Communication throughput calculation
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
    plot(P_r_range, eta_total, 'LineStyle', lineStyles{j}, 'Color', color, 'LineWidth', 1.5);
    hold on;    
end
yline(0.5, 'r', '\eta (P_r)', 'LabelHorizontalAlignment', 'left', 'FontSize', 12);
xlabel('P_r'); ylabel('Communication Throughput (bit/Hz)');
legend('P_c = 10 dB', 'P_c = 15 dB', 'P_c = 20 dB');
grid on;