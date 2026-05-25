clc; clear; close all;

% Parameters
sigma_SW2 = 1;
sigma_RW2 = 1;
sigma_RS2 = 1;
sigma_TR2 = 1;
sigma_RR2 = 1;
sigma_SR2 = 1;
sigma_SS2 = 1;
sigma_n2  = 1;

epsilon = 0.1;

P_R_dB = 15;
PR = 10^(P_R_dB/10);

P_S_dB = 15;
PS = 10^(P_S_dB/10);

alpha = 0.2;      % fixed
theta = 0.2;      % FIXED echo attenuation factor

% Beta range
beta_vec = logspace(-6, -2, 120);

xi = NaN(size(beta_vec));
Ik = NaN(size(beta_vec));

% Loop over beta
for k = 1:length(beta_vec)

    beta = beta_vec(k);

    % Compute Z and B
    Z = compute_Z(PS, PR, beta, theta, ...
                  sigma_SR2, sigma_RR2, sigma_TR2, sigma_n2, epsilon);

    B = compute_B(PS, beta, sigma_SS2, sigma_n2, epsilon);

    % Physical validity
    if isnan(Z) || Z <= 0 || isnan(B) || B <= 0 || alpha*Z >= 1
        continue;
    end

    % Detection error probability (Eq. 16)
    termA = exp( - (1 - alpha) * Z * sigma_n2 ...
                 / (PS * sigma_SW2 * (1 + alpha * Z)) );

    denomB = sigma_SW2 * PS * (1 - alpha * Z) ...
           + (1 - alpha) * Z * PR * sigma_RW2;
    denomB = max(denomB, eps);

    termB = (sigma_SW2 * PS * (1 + alpha * Z)) / denomB;
    termB = min(termB, 1e3);

    E = exp( - sigma_RS2 * B / sigma_RW2 );
    D = 1 + (PS * sigma_RS2 * B * sigma_SW2) ...
          / (sigma_n2 * sigma_RW2);

    termC1 = E / D;
    termC2 = 1 - termC1;

    xi(k) = 1 - termA * ( termB * termC2 + termC1 );
    xi(k) = max(0, min(1, xi(k)));

    % Radar mutual information (Eq. 24)
    SNR_radar = (sigma_TR2 * theta * PS) / ...
                (sigma_RR2 * beta * PR + sigma_n2);

    Ik(k) = log2(1 + SNR_radar);

end

% Trade-off plot
valid = ~isnan(xi) & ~isnan(Ik);

[xi_s, idx] = sort(xi(valid));
Ik_s = Ik(valid);
Ik_s = Ik_s(idx);

figure;
plot(xi_s, Ik_s, 'LineWidth',1.8);
xlabel('Detection error probability $\xi$','Interpreter','latex');
ylabel('Radar mutual information $I_K$','Interpreter','latex');
grid on;
box on;

% Performance vs beta
figure;

yyaxis left
semilogx(beta_vec, xi, 'LineWidth',1.6);
ylabel('Detection error probability $\xi$','Interpreter','latex');

yyaxis right
semilogx(beta_vec, Ik, '--', 'LineWidth',1.6);
ylabel('Radar mutual information $I_K$','Interpreter','latex');

xlabel('Self-interference factor $\beta$');
grid on;
box on;
