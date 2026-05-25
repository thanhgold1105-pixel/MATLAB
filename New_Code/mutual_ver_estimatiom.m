clc; clear; close all;

% Parameters and configurations
sigma_hc = 1;
sigma_n = 1;
sigma_gc = 1;
sigma_hr = 1;
sigma_gr = 1; 
N = 500;
P_r_value = 10;
P_r = 10^(P_r_value / 10);
P_avg_dB = 15; 
P_avg = 10^(P_avg_dB / 10);

% Define ranges for beta
beta_range = linspace(0, 1, 200); % Range for beta
delta = 4; % Fixed delta value for this plot
alpha_value = 0.01; % Fixed alpha value for this plot
B = 200000; % Bandwidth for radar mutual information

% Calculate radar mutual information (I_total) for beta range
I_total = zeros(length(beta_range), 1);

for p = 1:length(beta_range)
    beta = beta_range(p);

    % Calculate P_c and P_eff
    P_c = P_avg * exp(delta / ((1-beta) * sigma_hc));
    P_eff = alpha_value * P_avg + (1-alpha_value)*P_c;

    % Components of mutual information
    part_11 = (B*N) / (log(2) * (((N*alpha_value*P_avg*sigma_hr) / (sigma_gr*P_r)) + 1));
    part_21 = exp(sigma_n / (alpha_value*P_avg*sigma_hr)) * expint(sigma_n / (alpha_value*P_avg*sigma_hr));
    part_31 = exp((N*sigma_n) / (sigma_gr*P_r)) * expint((N*sigma_n) / (sigma_gr*P_r));

    part_41 = (B*N) / (log(2) * (((N*P_eff*sigma_hr) / (sigma_gr*P_r)) + 1));
    part_51 = exp(sigma_n / (P_eff*sigma_hr)) * expint(sigma_n / (P_eff*sigma_hr));
    part_61 = exp((N*sigma_n) / (sigma_gr*P_r)) * expint((N*sigma_n) / (sigma_gr*P_r));

    I_R = part_11 * (part_21 + part_31); 
    I_R_prime = part_41 * (part_51 + part_61);

    % Mutual information components
    I_1 = I_R * (1 - exp(-delta / ((1-beta)*sigma_hc)));
    I_2 = I_R_prime * exp(-delta / ((1-beta)*sigma_hc));

    I_total(p) = I_1 + I_2;
end

% Plotting
figure;
plot(beta_range, I_total, 'k-', 'LineWidth', 1.5);
xlabel('$\beta$', 'Interpreter', 'latex');
ylabel('Radar Mutual Information $I(\alpha,\delta)$', 'Interpreter', 'latex');
grid on;

