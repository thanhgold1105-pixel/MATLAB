clc; clear; close all;

%% ================== Parameters ==================
sigma_SW2 = 1;
sigma_RW2 = 1;
sigma_RS2 = 1;
sigma_TR2 = 1;
sigma_RR2 = 1;
sigma_SR2 = 1;
sigma_SS2 = 1;
sigma_n2  = 1;

epsilon = 0.1;
beta  = 1e-4;
theta = 0.1;

P_R_dB = 15;
PR = 10^(P_R_dB/10);

%% Alpha range (raw)
alpha = linspace(0.01, 0.99, 400);

%% Transmit power at S (dBW)
P_S_dB_values = [10, 15, 20];
lineStyles = {':', '--', '-.'};
color = 'k';

%% ================== Figure ==================
figure; hold on;

%% ================== Loop over PS ==================
for j = 1:length(P_S_dB_values)

    PS_dB = P_S_dB_values(j);
    PS = 10^(PS_dB/10);

    %% ===== Compute Z and B =====
    Z = compute_Z(PS, PR, beta, theta, ...
                  sigma_SR2, sigma_RR2, sigma_TR2, sigma_n2, epsilon);

    B = compute_B(PS, beta, sigma_SS2, sigma_n2, epsilon);

    % Check validity
    if isnan(Z) || Z <= 0 || isnan(B) || B <= 0
        continue;
    end

    %% ===== Physical constraint: alpha * Z < 1 =====
    alpha_valid = alpha(alpha .* Z < 0.9);   % margin for stability
    xi = zeros(size(alpha_valid));

    %% ===== Loop over alpha =====
    for i = 1:length(alpha_valid)

        a = alpha_valid(i);

        %% ---------- Term A ----------
        termA = exp( - (1 - a) * Z * sigma_n2 ...
                     / (PS * sigma_SW2 * (1 + a * Z)) );

        %% ---------- Term B ----------
        denomB = sigma_SW2 * PS * (1 - a * Z) ...
               + (1 - a) * Z * PR * sigma_RW2;
        denomB = max(denomB, eps);

        termB = (sigma_SW2 * PS * (1 + a * Z)) / denomB;
        termB = min(termB, 1e3);   % avoid blow-up

        %% ---------- Term C ----------
        E = exp( - sigma_RS2 * B / sigma_RW2 );
        D = 1 + (PS * sigma_RS2 * B * sigma_SW2) ...
              / (sigma_n2 * sigma_RW2);

        termC1 = E / D;        % exp(...) * inverse
        termC2 = 1 - termC1;

        %% ---------- Detection error probability ----------
        xi(i) = 1 - termA * ( termB * termC2 + termC1 );

        % Physical bounds
        xi(i) = max(0, min(1, xi(i)));
    end

    %% Plot
    plot(alpha_valid, xi, lineStyles{j}, ...
         'Color', color, 'LineWidth', 1.6);
end

%% ================== Plot format ==================
xlabel('\alpha');
ylabel('Detection error probability $\xi$', 'Interpreter','latex');
legend('P_S = 10 dB', 'P_S = 15 dB', 'P_S = 20 dB', 'Location','best');
grid on;
box on;
