clc; clear; close all;

% Parameters chung
sigma_ss = 1; sigma_sr = 1; sigma_rs = 1;
sigma_rr = 1; sigma_tr = 1;
sigma_sw = 1; sigma_rw = 1;
sigma_n  = 1;
epsilon  = 0.1;
beta     = 0.01;

alpha_range = linspace(0, 1, 200);
lineStyles  = {':', '--', '-.'};
color       = 'k';

%% Figure 1 — vary P_S, fixed P_R
Pr_dB = 30;
Pr    = 10^(Pr_dB/10);
P_s_dB = [13, 10, 15];

figure; hold on; grid on;
for i = 1:length(P_s_dB)
    Ps = 10^(P_s_dB(i)/10);
    Z  = compute_Z(sigma_sr, sigma_rr, sigma_tr, sigma_n, epsilon, beta, Pr, Ps);
    B  = compute_B(Ps, sigma_ss, sigma_n, epsilon, beta);
    xi = zeros(size(alpha_range));
    for j = 1:length(alpha_range)
        alpha  = alpha_range(j);
        term_1 = exp(-(1-alpha)*Z*sigma_n^2 / (Ps*sigma_sw^2*(1+alpha*Z)));
        term_2 = (sigma_sw^2*Ps*(1+alpha*Z)) / ...
                 (sigma_sw^2*Ps*(1+alpha*Z) + (1-alpha)*Z*Pr*sigma_rw^2);
        A      = exp(-(sigma_rs^2*B)/sigma_rw^2) * ...
                 (1 + (Ps*sigma_rs^2*B*sigma_sw^2)/(sigma_n^2*sigma_rw^2))^(-1);
        xi(j)  = max(0, min(1, 1 - term_1*(term_2*(1-A) + A)));
    end
    plot(alpha_range, xi, 'LineStyle', lineStyles{i}, 'Color', color, 'LineWidth', 1.5);
end
xlabel('\alpha');
ylabel('Detection error probability (\xi)');
legend(arrayfun(@(x) sprintf('P_S = %d dB', x), P_s_dB, 'UniformOutput', false));
title(sprintf('\\xi vs \\alpha, P_R = %d dB (fixed)', Pr_dB));

%% Figure 2 — vary P_R, fixed P_S
Ps_dB = 20;
Ps    = 10^(Ps_dB/10);
P_r_dB = [25, 30, 35];

figure; hold on; grid on;
for i = 1:length(P_r_dB)
    Pr = 10^(P_r_dB(i)/10);
    Z  = compute_Z(sigma_sr, sigma_rr, sigma_tr, sigma_n, epsilon, beta, Pr, Ps);
    B  = compute_B(Ps, sigma_ss, sigma_n, epsilon, beta);
    xi = zeros(size(alpha_range));
    for j = 1:length(alpha_range)
        alpha  = alpha_range(j);
        term_1 = exp(-(1-alpha)*Z*sigma_n^2 / (Ps*sigma_sw^2*(1+alpha*Z)));
        term_2 = (sigma_sw^2*Ps*(1+alpha*Z)) / ...
                 (sigma_sw^2*Ps*(1+alpha*Z) + (1-alpha)*Z*Pr*sigma_rw^2);
        A      = exp(-(sigma_rs^2*B)/sigma_rw^2) * ...
                 (1 + (Ps*sigma_rs^2*B*sigma_sw^2)/(sigma_n^2*sigma_rw^2))^(-1);
        xi(j)  = max(0, min(1, 1 - term_1*(term_2*(1-A) + A)));
    end
    plot(alpha_range, xi, 'LineStyle', lineStyles{i}, 'Color', color, 'LineWidth', 1.5);
end
xlabel('\alpha');
ylabel('Detection error probability (\xi)');
legend(arrayfun(@(x) sprintf('P_R = %d dB', x), P_r_dB, 'UniformOutput', false));
title(sprintf('\\xi vs \\alpha, P_S = %d dB (fixed)', Ps_dB));

%% Functions
function Z = compute_Z(sigma_sr, sigma_rr, sigma_tr, sigma_n, epsilon, beta, Pr, Ps)
    main_denom = beta*Pr*sigma_rr^2 + Ps*sigma_tr^2;
    in_lambert = (sigma_n^2 * exp(sigma_n^2/main_denom)) / ((1-epsilon)*main_denom);
    Z = (Ps*sigma_sr^2/sigma_n^2)*lambertw(0,in_lambert) - (Ps*sigma_sr^2/main_denom);
end

function B = compute_B(Ps, sigma_ss, sigma_n, epsilon, beta)
    denom      = beta*Ps*sigma_ss^2;
    in_lambert = (sigma_n^2 * exp(sigma_n^2/denom)) / ((1-epsilon)*denom);
    B = lambertw(0,in_lambert) - sigma_n^2/denom;
end