clc;clear;close all;

% Define parameters
T = [1 2 3];                          
alpha = 0:0.001:1;                    
P_c_dBm = 80;                         
P_r_dBm = 20;                 

P_c_value = 10^(P_c_dBm / 10);        
P_r_value = 10.^(P_r_dBm ./ 10);      

sigma_cr = 1;
sigma_n = 1;
sigma_rr = 1;

% Initialize epsilon
epsilon = zeros(length(T), length(P_r_value), length(alpha));
P_MD = zeros(length(T), length(P_r_value), length(alpha));
% Compute epsilon
for t_idx = 1:length(T)             
    for er_idx = 1:length(P_r_value) 
        for a_idx = 1:length(alpha) % Loop over alpha
            T_t = alpha(a_idx) * T(t_idx);   % Training time
            rho = (sigma_cr * P_c_value * T_t) / (sigma_n + sigma_rr * P_r_value(er_idx));
            beta = 1 / (1 + rho);

            a = P_r_value(er_idx) * sigma_rr;
            b = P_c_value * sigma_cr * beta;

            if a ~= b
                epsilon(t_idx, er_idx, a_idx) = (b / a)^(b / (a - b));
            else
                epsilon(t_idx, er_idx, a_idx) = 1;
            end
            P_MD(t_idx,er_idx,a_idx)= 1- epsilon(t_idx,er_idx,a_idx);
        end
    end
end

% Maximize epsilon over P_r
opt_epsilon = zeros(length(alpha), length(T));

for t_idx = 1:length(T)
    for a_idx = 1:length(alpha)
        opt_epsilon(a_idx, t_idx) = max(P_MD(t_idx, :, a_idx)); % maximize over P_r
    end
end

% Plot epsilon* vs alpha for each T
pattern = {':', '--', '-.'};
figure;
hold on;
legendInfo = cell(1, length(T));

for t_idx = 1:length(T)
    plot(alpha, opt_epsilon(:, t_idx), 'k', ...
         'LineStyle', pattern{mod(t_idx-1, length(pattern))+1}, ...
         'LineWidth', 1.5);
    legendInfo{t_idx} = sprintf('$$ T = %d \\; \\mathrm{s} $$', T(t_idx));
end

legend(legendInfo, 'Interpreter', 'latex', 'Location', 'east');
grid on;
xlabel('Pilot coefficient $$ \alpha $$', 'Interpreter', 'latex');
ylabel("Radar detection error probability at CR $$ \xi_{min} $$", 'Interpreter', 'latex');

xlim([0 1]);
ylim([0.4 1]);
