clc; clear; close all;

% ===== Define parameters =====
sigma_SR2 = 1;
sigma_RR2 = 1;
sigma_TR2 = 1;
sigma_SS2 = 1;
sigma_RW2 = 1;
sigma_SW2 = 1;
sigma_n2  = 1;

epsilon = 1e-2;
beta    = 1e-3;                 % -30 dB
theta_range = linspace(1e-4, 1e-2, 60);

Ps_dB = 40;
Ps = 10^(Ps_dB/10);

Pr_dB = [15 25 30];
lineStyles = {':','--','-'};

figure; hold on; grid on;

for i = 1:length(Pr_dB)

    Pr = 10^(Pr_dB(i)/10);
    xi = zeros(1, length(theta_range));
    
    for j = 1:length(theta_range)

        theta = theta_range(j);
        
        % ===== Các biến phụ của bạn =====
        B = compute_B(Ps, sigma_SS2, sigma_n2, beta, epsilon);
        Z = compute_Z(Ps, Pr, sigma_SR2, sigma_RR2, sigma_TR2, sigma_n2, beta, theta, epsilon);

        % ===== Tính theo (16) =====

        % --- A ---
        term_A = (1 - theta)*Z*sigma_n2 / (Ps*sigma_SW2*(1 + theta*Z));

        % --- T1 ---
        T1 = (sigma_SW2*Ps*(1 + theta*Z)) / ...
             (sigma_SW2*Ps*(1 - theta*Z) + (1 - theta)*Z*Pr*sigma_RW2);

        % --- Phần chứa B ---
        expB = exp(-sigma_SR2*B/sigma_RW2);

        invB = 1 / (1 + Ps*sigma_SR2*B*sigma_SW2/(sigma_n2*sigma_RW2));

        T2 = 1 - expB * invB;

        T3 = expB * invB;

        % --- Công thức cuối ---
        xi(j) = 1 - exp(-term_A) * (T1*T2 + T3);

    end

    plot(theta_range, xi, lineStyles{i}, 'LineWidth', 2, ...
        'DisplayName', ['P_r = ' num2str(Pr_dB(i)) ' dB']);

end

xlabel('\theta');
ylabel('\xi');
legend show;
title('Outage Probability theo \theta');
