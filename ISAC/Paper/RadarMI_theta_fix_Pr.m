% MI versus theta for different Ps
clc; clear; close all;

% Define parameters
sigma_sr = 1;
sigma_rr = 1;
sigma_tr = 1;
sigma_n = 1;

epsilon = 0.3;
beta = 0.7;

theta_range = linspace(0.01,0.11,40);

Pr_dB = 15;
Pr = 10^(Pr_dB/10);

P_s_dB = [20, 30, 40];
lineStyles = {':','--','-.'};
color = 'k';

figure; hold on; grid on;

% Loop Ps
for i = 1:length(P_s_dB)

    Ps = 10^(P_s_dB(i)/10);
    MI = zeros(size(theta_range));

    for j = 1:length(theta_range)
        theta = theta_range(j);

        H = compute_H(Ps, Pr, sigma_sr, sigma_rr, sigma_tr, sigma_n, beta, theta, epsilon);

        % Term 1
        numer_term_1 = exp( - H*sigma_n^2 / (Ps*sigma_sr^2) );
        denom_term_1 = (1 + H*theta*(sigma_tr^2)/sigma_sr^2) * (1 + H*beta*(Pr*sigma_rr^2)/(Ps*sigma_sr^2));
        term_1 = numer_term_1/denom_term_1;

        % Term 2
        kappa  = sigma_n^2 / (theta * Ps * sigma_tr^2);
        lambda = sigma_n^2 / (beta  * Pr * sigma_rr^2);
        numer_term_2 = exp(lambda).*expint(lambda) - exp(kappa).*expint(kappa);
        denom_term_2 = (beta * Pr * sigma_rr^2) / (theta * Ps * sigma_tr^2) - 1 ;
        term_2 = (1 / log(2)) * (numer_term_2/denom_term_2);

        % Radar Mutual Information
        MI(j) = term_1 * term_2;
    end
    % Plot
    plot(theta_range, MI, 'LineStyle', lineStyles{i}, 'Color', color, 'LineWidth', 1.5);
end
xlabel('\theta');
ylabel('Radar Mutual Information');
legend(arrayfun(@(x) sprintf('P_S = %d dB', x), P_s_dB, 'UniformOutput', false));
title('Sensing mutual information vs \theta')