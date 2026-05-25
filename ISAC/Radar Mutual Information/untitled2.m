clc; clear; close all;

% Parameters
sigma_tr = 1;
sigma_rr = 1;
sigma_n  = 1;

beta = 0.05;

theta_range = linspace(0.01,0.1,40);

Ps_dB = 50;
Ps = 10^(Ps_dB/10);

P_r_dB = [10, 15, 20];

N = 1e5;   % Monte Carlo samples

figure; hold on; grid on;

for i = 1:length(P_r_dB)

    Pr = 10^(P_r_dB(i)/10);
    MI = zeros(size(theta_range));

    % Generate fading samples
    X = exprnd(sigma_tr^2, N, 1);
    Y = exprnd(sigma_rr^2, N, 1);

    for j = 1:length(theta_range)

        theta = theta_range(j);

        SINR = (theta*Ps*X) ./ (beta*Pr*Y + sigma_n^2);

        MI(j) = mean(log2(1 + SINR));

    end

    plot(theta_range, MI, 'LineWidth', 1.5);
end

xlabel('\theta');
ylabel('Ergodic Radar Mutual Information');
legend('P_R = 10 dB','P_R = 15 dB','P_R = 20 dB');