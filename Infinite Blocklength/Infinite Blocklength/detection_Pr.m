clc;
clear;
close all;

% Define parameters
T 	= 1;
alpha 	= 0:0.0001:1; 
T_act 	= T .* alpha; 
T_remain = (1 - alpha) .* T;
P_c = [40 50 60]; % in dBm
P_r = 0:1:100; % in dBm
P_c_value =  10.^(P_c ./ 10); 
P_r_value = 10.^(P_r ./ 10); 
sigma_cr = 1;
sigma_n = 1;
sigma_rr = 1;

% Initialize epsilon and P_MD with the correct dimensions
epsilon = zeros(length(P_c), length(P_r_value), length(alpha));
P_MD = zeros(length(P_c), length(P_r_value), length(alpha));

% Compute error coefficient and epsilon
for i = 1:length(P_c_value) 
    for j = 1:length(P_r_value) 
        for k = 1:length(alpha) 
            t_act = T_act(k); 
            t_remain = T_remain(k); 
            rho = (sigma_cr * P_c_value(i) * t_act) / (sigma_n + sigma_rr * P_r_value(j));
            beta = 1 ./ (1 + rho );
            a = P_r_value(j) * sigma_rr;
            b = P_c_value(i) * sigma_cr .* beta;
            
            % Ensure no division by zero or invalid power operation
            if a ~= b
                epsilon(i, j, k) = (b./a).^(b./(a-b));
            else
                epsilon(i, j, k) = 1; % Assign a valid value in case of singularity
            end
            
            % Compute P_MD correctly
            P_MD(i, j, k) = 1 - epsilon(i, j, k);

        end
    end
end

% Plot for a selected alpha value (e.g., alpha = 0.5)
alpha_index = find(alpha == 0.5, 1); % Find index where alpha = 0.5

if isempty(alpha_index)
    error('Selected alpha value not found in array.');
end

pattern = {':', '--', '-.'};
figure();
hold on;
legendInfo = cell(1, numel(P_c));

for p = 1:numel(P_c)
    plot(P_r, squeeze(P_MD(p, :, alpha_index)), 'k', 'LineStyle', pattern{p}, 'LineWidth', 1.5);
    legendInfo{p} = sprintf('$$P_c = %d \\; \\mathrm{dBm}$$', P_c(p));
end

legend(legendInfo, 'Interpreter', 'latex', 'Location', 'east');
grid on;
xlabel('Transmit power of radar $$ P_r(\mathrm{dBm})$$', 'Interpreter', 'latex');
ylabel("Radar detection error probability at CR $$ \xi_{min} $$", 'Interpreter', 'latex');
