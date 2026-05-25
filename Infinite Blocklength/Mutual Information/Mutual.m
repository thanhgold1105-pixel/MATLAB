clc; clear; close all;

% System Parameter
B = 200000;                   % Bandwidth (Hz)
T = 1;                        % Observation time (s)
P_r_dB = 10;                  % Radar transmit power in dBW
P_r = 10^(P_r_dB / 10);       % Radar transmit power in watts
sigma_ht = 1;                 % Channel variance (target reflection)
sigma_hs = 1;                 % Channel variance (self-interference)
sigma_n = 1;                  % Noise standard deviation

% Define range of rho values
rho_range = linspace(0.01, 1, 200);  % Avoid 0 to prevent division by zero

% Communication transmit power levels
P_c_dB_values = [5, 10, 15];        % Communication transmit power in dBW
lineStyles = {':', '--', '-.'};     % Line styles for different powers
color = 'k';                        % Use black for all plots

% Plotting setup
figure; hold on;

% Loop over communication power values
for j = 1:length(P_c_dB_values)
    P_c_dB = P_c_dB_values(j);
    P_c = 10^(P_c_dB / 10);   % Convert to linear scale
    
    % Calculate mutual information for each rho
    MI_total = zeros(size(rho_range));
    
    for i = 1:length(rho_range)
        rho = rho_range(i);
        
        % Components of mutual information
        term_1 = (B*T)/(log(2)*((T*rho*P_c*(sigma_hs^2))/((sigma_ht^2)*P_r)+1));
        term_2 = exp((sigma_n^2)/(rho*P_c*(sigma_hs^2)));
        term_3 = (sigma_n^2)/(rho*P_c*(sigma_hs^2));
        term_4 = exp((T*sigma_n^2)/((sigma_ht^2)*P_r));
        term_5 = (T*sigma_n^2)/((sigma_ht^2)*P_r);
        
        % Mutual information expression
        MI_total(i) = term_1*(term_2*expint(term_3) + term_4*expint(term_5));
    end
    
    % Plotting
    plot(rho_range, MI_total, lineStyles{j}, 'Color', color, 'LineWidth', 1.5, ...
        'DisplayName', ['$P_c$ = ', num2str(P_c_dB), ' dBW']);
end

xlabel('$\rho$', 'Interpreter', 'latex');
ylabel('Radar Mutual Information $MI_R(\rho)$', 'Interpreter', 'latex');
grid on;
legend('Interpreter', 'latex', 'Location', 'best');
title('Radar Mutual Information vs $\rho$', 'Interpreter', 'latex');