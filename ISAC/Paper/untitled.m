clc; clear; close all;

% Parameters
sigma_ss = 1;
sigma_sr = 1;
sigma_rs = 1;
sigma_rr = 1;
sigma_tr = 1;
sigma_sw = 1;
sigma_rw = 1;
sigma_n  = 1;
epsilon  = 0.1;
beta     = 0.01;

Pr_dB = 30;
Pr = 10^(Pr_dB/10);

% Dải P_S rộng hơn
Ps_dB_range = linspace(0, 50, 300);

% Thử vài giá trị alpha cố định
alpha_vals = [0.2, 0.5, 0.8];
lineStyles = {':', '--', '-.'};

figure; hold on; grid on;

for i = 1:length(alpha_vals)
    alpha = alpha_vals(i);
    xi_vec = zeros(size(Ps_dB_range));

    for j = 1:length(Ps_dB_range)
        Ps = 10^(Ps_dB_range(j)/10);

        Z = compute_Z(sigma_sr, sigma_rr, sigma_tr, sigma_n, epsilon, beta, Pr, Ps);
        B = compute_B(Ps, sigma_ss, sigma_n, epsilon, beta);

        term_1 = exp(-(1-alpha)*Z*sigma_n^2 / ...
                     (Ps*sigma_sw^2*(1+alpha*Z)));
        term_2 = (sigma_sw^2*Ps*(1+alpha*Z)) / ...
                 (sigma_sw^2*Ps*(1+alpha*Z) + (1-alpha)*Z*Pr*sigma_rw^2);
        A = exp(-(sigma_rs^2*B) / sigma_rw^2) * ...
            (1 + (Ps*sigma_rs^2*B*sigma_sw^2) / ...
                 (sigma_n^2*sigma_rw^2))^(-1);

        xi_val = 1 - term_1*(term_2*(1-A) + A);
        xi_vec(j) = max(0, min(1, xi_val));
    end

    plot(Ps_dB_range, xi_vec, ...
        'LineStyle', lineStyles{i}, ...
        'Color', 'k', ...
        'LineWidth', 1.5);
end

xlabel('P_S (dB)');
ylabel('Detection error probability (\xi)');
legend(arrayfun(@(x) sprintf('\\alpha = %.1f', x), alpha_vals, 'UniformOutput', false));
title(sprintf('\\xi vs P_S (wide range), P_R = %d dB', Pr_dB));

%% Functions
function Z = compute_Z(sigma_sr, sigma_rr, sigma_tr, sigma_n, epsilon, beta, Pr, Ps)
    main_denom = beta*Pr*sigma_rr^2 + Ps*sigma_tr^2;
    in_lambert = (sigma_n^2 * exp(sigma_n^2/main_denom)) / ...
                 ((1-epsilon) * main_denom);
    W = lambertw(0, in_lambert);
    Z = (Ps*sigma_sr^2/sigma_n^2)*W - (Ps*sigma_sr^2/main_denom);
end

function B = compute_B(Ps, sigma_ss, sigma_n, epsilon, beta)
    denom      = beta*Ps*sigma_ss^2;
    in_lambert = (sigma_n^2 * exp(sigma_n^2/denom)) / ...
                 ((1-epsilon) * denom);
    W = lambertw(0, in_lambert);
    B = W - sigma_n^2/denom;
end