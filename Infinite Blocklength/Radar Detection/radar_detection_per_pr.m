clc; clear; close all;

% Initial parameters
sigma_rr = 1;
sigma_cr = 1;
sigma_n = 1;
T = 1;
alpha = 0.4;

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
    xi_total = zeros(size(P_r_range));
        
    for i = 1:length(P_r_range)
        P_r_dB = P_r_range(i);
        P_r = 10^(P_r_dB / 10);

        % Beta calculations
        beta_first_part = sigma_cr^2 * P_c;
        beta_second_part = (sigma_rr^2 * P_r) + sigma_n^2;
        beta_whole_part = beta_first_part/beta_second_part;
        beta_denominator = 1 + (alpha * T * beta_whole_part);
        beta_i = 1/beta_denominator;
        beta(i) = beta_i;

        % Radar detection calculation
        num1 = beta_i * sigma_cr^2 * P_c;
        deno1 = sigma_rr^2 * P_r;
        deno2 = (beta_i * sigma_cr^2 * P_c) - (sigma_rr^2 * P_r);

        func1 = num1/deno1;
        func2 = - num1/deno2;

        xi_total(i) = 1 - func1^func2;
    end
    % Plot each curve
    plot(P_r_range, xi_total, lineStyles{j}, 'Color', color, 'LineWidth', 1.5);
    
end 
yline(0.7, 'r', '\xi*', 'LabelHorizontalAlignment', 'left', 'FontSize', 12);

% Final plot settings
xlabel('P_r');  
ylabel('Radar detection error probability \xi *');
legend('P_c = 10 dB', 'P_c = 15 dB', 'P_c = 20 dB');
grid on;