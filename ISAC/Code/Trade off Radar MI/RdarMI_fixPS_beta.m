clc; clear; close all;

%% ================== Parameters ==================
sigma_TR2 = 1;
sigma_RR2 = 1;
sigma_n2  = 1;

theta = 0.2;              % fixed echo attenuation
P_R_dB = 15;
PR = 10^(P_R_dB/10);

%% ================== Beta range ==================
beta_vec = logspace(-6, -2, 200);

%% ================== PS values ==================
P_S_dB_values = [10 15 20];
lineStyles = {':','--','-'};

figure; hold on;

for i = 1:length(P_S_dB_values)

    PS = 10^(P_S_dB_values(i)/10);

    SNR_radar = (sigma_TR2 * theta * PS) ./ ...
                (sigma_RR2 .* beta_vec * PR + sigma_n2);

    Ik = log2(1 + SNR_radar);

    semilogx(beta_vec, Ik, lineStyles{i}, 'LineWidth',1.8);
end

xlabel('Self-interference factor $\beta$','Interpreter','latex');
ylabel('Radar mutual information $I_K$','Interpreter','latex');
legend('$P_S=10$ dB','$P_S=15$ dB','$P_S=20$ dB', ...
       'Interpreter','latex','Location','best');
grid on;
box on;
