clc; clear; close all;

% --- Parameters
sigma_sr2 = 1; sigma_sw2 = 1;
sigma_rw2 = 1; sigma_rs2 = 1;
sigma_rr2 = 1; sigma_ss2 = 1;

sigma_n2 = 1; epsilon = 0.05;

P_s_dB = 10;
P_s = 10^(P_s_dB / 10);
beta = 0.5;

alpha_range = linspace(0, 1, 200);
P_r_dB = 15;                   % chọn 1 giá trị trung bình để phân tích
P_r = 10^(P_r_dB / 10);

% --- Compute Z and C
argZ = (sigma_n2 / (beta * P_r * sigma_rr2)) * ...
       exp( (sigma_n2 / (beta * P_r * sigma_rr2)) - log(1 - epsilon) );
Z = real(lambertw(0, argZ));

argC = ((beta * P_s * sigma_ss2) / (P_r * sigma_rs2)) * ...
       exp( ((beta * P_s * sigma_ss2) / (P_r * sigma_rs2)) - log(1 - epsilon) );
C = (sigma_rs2 / (beta * P_s * sigma_ss2)) * real(lambertw(0, argC));

% --- Allocate arrays
xi_cS_vals = zeros(size(alpha_range));
xi_cR_vals = zeros(size(alpha_range));
xi_cS_R_vals = zeros(size(alpha_range));
xi_total_vals = zeros(size(alpha_range));

for i = 1:length(alpha_range)
    alpha = alpha_range(i);

    % ξ_cS (Eq.9)
    helper = (alpha * P_s * sigma_sr2 / sigma_n2) * Z;
    expo_arg = - (Z * (1 - alpha) * sigma_sr2 / sigma_sw2) * (1 + helper);
    mult_term = 1 + (P_r * sigma_rw2 * sigma_sr2) / (sigma_n2 * sigma_sw2) * ...
                (Z * (1 - alpha)) / (1 + helper);
    xi_cS = 1 - exp(expo_arg) * (mult_term)^(-1);

    % ξ_cR (Eq.10)
    xi_cR = 1 - ( sigma_rw2 / (sigma_rw2 + C * P_s * sigma_sw2) ) * ...
                exp( - C * sigma_n2 / sigma_rw2 );

    % ξ_cS|R (Eq.12)
    num = sigma_n2 * sigma_sr2 * Z * (1 - alpha);
    den = sigma_sw2 * ( sigma_n2 + alpha * P_s * sigma_sr2 * Z );
    xi_cS_R = 1 - exp( - num / den );

    % Tổng (Eq.13)
    xi_total = xi_cS_R * (1 - xi_cR) + xi_cS * xi_cR;

    % Lưu lại
    xi_cS_vals(i) = xi_cS;
    xi_cR_vals(i) = xi_cR;
    xi_cS_R_vals(i) = xi_cS_R;
    xi_total_vals(i) = xi_total;
end

% --- Plot
figure; hold on;
plot(alpha_range, xi_cS_vals, 'r-', 'LineWidth', 1.6);
plot(alpha_range, xi_cR_vals, 'b--', 'LineWidth', 1.6);
plot(alpha_range, xi_cS_R_vals, 'm-.', 'LineWidth', 1.6);
plot(alpha_range, xi_total_vals, 'k', 'LineWidth', 2);
xlabel('$\alpha$', 'Interpreter', 'latex');
ylabel('Probability', 'Interpreter', 'latex');
legend({'$\xi_{c_S}$', '$\xi_{c_R}$', '$\xi_{c_S|R}$', '$\xi_{total}$'}, ...
       'Interpreter', 'latex', 'Location', 'best');
title(sprintf('Components of $\\xi_{total}$ at $P_R = %d$ dBW', P_r_dB), 'Interpreter', 'latex');
grid on;
