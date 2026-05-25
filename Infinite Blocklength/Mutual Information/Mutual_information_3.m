clc; clear; close all;

% Parameters and configurations
T = 1;
sigma_n = 1;
sigma_cbs = 1;
sigma_rt = 1;
P_c_dB = 20;
P_c = 10^(P_c_dB / 10);
P_r_dB = 2.86;
P_r = 10^(P_r_dB / 10);
B = 200000; 
color = 'k';

% Define range for rho
rho_range = linspace(0.0001, 1, 200);  % Avoid zero to prevent divide-by-zero

% Prepare figure
figure; hold on;

% Preallocate MI array
I_max = zeros(size(rho_range));

for i = 1:length(rho_range)
    rho = rho_range(i);
    
    % Intermediate calculations
        term1_num = B * T;
        part1_num = T * rho * P_c * sigma_cbs^2;
        part1_deno = P_r * sigma_rt^2;
        part1 = part1_num/part1_deno;
        term1_deno = log(2) * (part1 + 1);
        term1 = term1_num/term1_deno;

        part2_num = sigma_n^2;
        part2_deno = rho * P_c * sigma_cbs^2;
        part2 = part2_num/part2_deno;
        term2_1 = exp(part2);
        term2_2 = expint(part2);
        term2 = term2_1 * term2_2;

        part3_num = T * sigma_n^2;
        part3_deno = P_r * sigma_rt^2;
        part3 = part3_num/part3_deno;
        term3_1 = exp(part3);
        term3_2 = expint(part3);
        term3 = term3_1 * term3_2;

        I_max(i) = term1 * (term2 + term3);
end
% Plot each curve
plot(rho_range, I_max, '-', 'Color', color, 'LineWidth', 1.5);
xlabel('$\rho$', 'Interpreter', 'latex');
ylabel('Radar Mutual Information $I_{max}(\rho)$', 'Interpreter', 'latex');
grid on;