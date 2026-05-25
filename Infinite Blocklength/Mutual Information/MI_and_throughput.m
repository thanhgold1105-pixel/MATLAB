% Fix parameters
T = 1;
sigma_cr = 1;
sigma_rr = 1;
sigma_n = 1;
P_c_dB = 10;
P_c = 10^(P_c_dB / 10);
B = 200000;
sigma_cbs = 1;
sigma_rt = 1;
rho = 0.5;

% Define range for alpha
alpha_range = linspace(0, 1, 200);

% Communication transmit power levels (in dBW)
P_r_dB_values = [10, 15];
lineStyles = {'--', '-.'};
color = 'k';  

% Prepare figure
figure(1); hold on; % Hình vẽ cho eta_total
figure(2); hold on; % Hình vẽ cho I_total

for j = 1:length(P_r_dB_values)
    P_r_dB = P_r_dB_values(j);
    P_r = 10^(P_r_dB / 10);

    % Preallocate arrays
    beta = zeros(size(alpha_range));
    I_total = zeros(size(alpha_range));
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
        
        % Each mutual part
        section_1_numerator = B * T;
        element_1_numerator = T * rho * P_c * sigma_cbs^2;
        element_1_denominator = sigma_rt^2 * P_r;
        element_1 = element_1_numerator/element_1_denominator;
        section_1_denominator = log(2) * (element_1 + 1);
        section_1 = section_1_numerator/section_1_denominator;

        section_2 = (sigma_n^2) / (rho * P_c * sigma_cbs^2);
        section_2_exp = exp(section_2);
        section_2_expint = expint(section_2);
        
        component_2 = section_2_exp * section_2_expint;

        section_3 = (T * sigma_n^2)/(sigma_rt^2 * P_r);
        section_3_exp = exp(section_3);
        section_3_expint = expint(section_3);

        component_3 = section_3_exp * section_3_expint;

        % Calculate I total
        I_total(i) = section_1*(component_2 + component_3);
    end
    % Plot eta_total ở Figure 1
    figure(1);
    plot(alpha_range, eta_total, 'LineStyle', lineStyles{j}, 'Color', color, 'LineWidth', 1.5);

    % Plot I_total ở Figure 2
    figure(2);
    plot(alpha_range, I_total, 'LineStyle', lineStyles{j}, 'Color', color, 'LineWidth', 1.5);

end

% Customize Figure 1 (eta)
figure(1);
xlabel('\alpha'); ylabel('\eta');
legend('\eta, P_r = 10 dBW', '\eta, P_r = 15 dBW');
grid on; title('Radar metric \eta vs \alpha');

% Customize Figure 2 (I)
figure(2);
xlabel('\alpha'); ylabel('I');
legend('I, P_r = 10 dBW', 'I, P_r = 15 dBW');
grid on; title('Mutual Information I vs \alpha');