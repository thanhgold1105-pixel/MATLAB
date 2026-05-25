clc; clear; close all;

% Parameters
sigma_ss = 1; sigma_sr = 1; sigma_rs = 1;
sigma_rr = 1; sigma_tr = 1;
sigma_sw = 1; sigma_rw = 1;
sigma_n  = 1;
epsilon  = 0.1;
beta     = 0.00001;
N_sim    = 1e6;

alpha_range = linspace(0, 0.9, 20);  % ít điểm cho MC đỡ nặng
Pr_dB = 25; Pr = 10^(Pr_dB/10);
P_s_dB = [5, 10, 15];
lineStyles = {':', '--', '-.'};
mcMarkers  = {'s', 'o', '^'};

figure; hold on; grid on;

for i = 1:length(P_s_dB)
    Ps = 10^(P_s_dB(i)/10);
    Z  = compute_Z(sigma_sr, sigma_rr, sigma_tr, sigma_n, epsilon, beta, Pr, Ps);
    B  = compute_B(Ps, sigma_ss, sigma_n, epsilon, beta);

    xi_anal = zeros(size(alpha_range));
    xi_mc   = zeros(size(alpha_range));

    % Sinh kênh 1 lần dùng cho tất cả alpha
    h_sw = sqrt(sigma_sw^2/2)*(randn(N_sim,1)+1j*randn(N_sim,1));
    h_rw = sqrt(sigma_rw^2/2)*(randn(N_sim,1)+1j*randn(N_sim,1));

    RR_val        = log2(1 + Pr*sigma_rs^2/sigma_n^2 * B);
    MI_cR_yW      = log2(1 + abs(h_rw).^2*Pr ./ (abs(h_sw).^2*Ps + sigma_n^2));
    can_decode_cR = (MI_cR_yW >= RR_val);
    MI_case1      = log2(1 + abs(h_sw).^2*Ps ./ (abs(h_rw).^2*Pr + sigma_n^2));
    MI_case2      = log2(1 + abs(h_sw).^2*Ps / sigma_n^2);
    MI_total      = MI_case1.*(~can_decode_cR) + MI_case2.*can_decode_cR;

    for j = 1:length(alpha_range)
        alpha = alpha_range(j);

        % Analytical
        term_1 = exp(-(1-alpha)*Z*sigma_n^2 / (Ps*sigma_sw^2*(1+alpha*Z)));
        term_2 = (sigma_sw^2*Ps*(1+alpha*Z)) / ...
                 (sigma_sw^2*Ps*(1+alpha*Z) + (1-alpha)*Z*Pr*sigma_rw^2);
        A = exp(-(sigma_rs^2*B)/sigma_rw^2) * ...
            (1 + (Ps*sigma_rs^2*B*sigma_sw^2)/(sigma_n^2*sigma_rw^2))^(-1);
        xi_anal(j) = max(0, min(1, 1 - term_1*(term_2*(1-A) + A)));

        % Monte Carlo
        RS_alpha = log2((1+Z)/(1+alpha*Z));
        xi_mc(j) = mean(MI_total < RS_alpha);
    end

    plot(alpha_range, xi_anal, 'LineStyle', lineStyles{i}, ...
         'Color', 'k', 'LineWidth', 1.5, ...
         'DisplayName', sprintf('P_S = %d dB (analytical)', P_s_dB(i)));
    plot(alpha_range, xi_mc, 'LineStyle', 'none', ...
         'Marker', mcMarkers{i}, 'Color', 'k', 'MarkerSize', 6, ...
         'DisplayName', sprintf('P_S = %d dB (MC)', P_s_dB(i)));
end

xlabel('\alpha');
ylabel('Detection error probability (\xi)');
legend('Location', 'southwest');
title(sprintf('Analytical vs Monte Carlo, P_R = %d dB', Pr_dB));

%% Functions
function Z = compute_Z(sigma_sr, sigma_rr, sigma_tr, sigma_n, epsilon, beta, Pr, Ps)
    main_denom = beta*Pr*sigma_rr^2 + Ps*sigma_tr^2;
    in_lambert = (sigma_n^2 * exp(sigma_n^2/main_denom)) / ((1-epsilon)*main_denom);
    Z = (Ps*sigma_sr^2/sigma_n^2)*lambertw(0,in_lambert) - (Ps*sigma_sr^2/main_denom);
end

function B = compute_B(Ps, sigma_ss, sigma_n, epsilon, beta)
    denom = beta*Ps*sigma_ss^2;
    in_lambert = (sigma_n^2 * exp(sigma_n^2/denom)) / ((1-epsilon)*denom);
    B = lambertw(0,in_lambert) - sigma_n^2/denom;
end