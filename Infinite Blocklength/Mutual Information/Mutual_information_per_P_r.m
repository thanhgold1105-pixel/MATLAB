clc; clear; close all;

% Parameters and configurations
T = 0.4;
sigma_n = 1;
sigma_cbs = 1;
sigma_rt = 1;
B = 200000;
rho = 0.4;

% Defined radar power range
P_r_range = linspace(-20, 50, 200);

% Radar power levels (in dBW)
P_c_dB_values = [10, 15, 20];
lineStyles = {':', '--', '-.'};     % Line styles
color = 'k';

% Prepare figure
figure; hold on;

% Preallocate MI array
I_max = zeros(size(P_r_range));

% Loop over each radar power level~
for j = 1:length(P_c_dB_values)
    P_c_dB = P_c_dB_values(j);
    P_c = 10^(P_c_dB / 10);  % Convert dBW to linear scale

    for i = 1:length(P_r_range)
        P_r_dB = P_r_range(i);
        P_r = 10^(P_r_dB / 10); % Convert dBW to linear scale

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
    plot(P_r_range, I_max, lineStyles{j}, 'Color', color, 'LineWidth', 1.5);
end
xlabel('P_r');  
ylabel('Radar Mutual Information $I_{max}$', 'Interpreter', 'latex');
legend('P_c = 10 dB', 'P_c = 15 dB', 'P_c = 20 dB');
grid on;        