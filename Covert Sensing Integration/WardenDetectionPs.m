% Define parameters
P_R = 0.5;
sigma_n = 0.1;  
sigma_SW = 1;   
sigma_RW = 1;   
sigma_SR = 1;   
beta = 0.5;        
epsilon = 1e-5;    

% Define sender power range
P_S_range = linspace(-10, 20, 40);

% Define alpha values
alpha_values = [0.2, 0.5, 0.8];

% Prepare figure
lineStyles = {':', '--', '-.'}; 
colors = {'k', 'b', 'r'};         
legend_entries = cell(1, length(alpha_values)); 
figure;
hold on;

% Loop over alpha
for j = 1:length(alpha_values)
    
    alpha = alpha_values(j);
    
    % Preallocate arrays
    xi_results = zeros(size(P_S_range));
    for i = 1:length(P_S_range)
        
        P_S_dB = P_S_range(i);

        P_S = 10^(P_S_dB / 10);
        
        C = @(x) (x * (1 - alpha) * P_S) ./ ...
            (sigma_n + x * alpha * P_S + beta * P_R * (-log(epsilon)));
        
        % Integral
        integrand = @(x) (1 - exp( -(C(x) .* sigma_n) ./ ...
            (P_S * sigma_SW + C(x) .* P_R .* sigma_RW) )) .* ...
            (exp(-x ./ sigma_SR) ./ sigma_SR);
            
        % Final result
        xi_results(i) = integral(integrand, 0, inf);
        
    end
    
    % Plot Figure
    semilogy(P_S_range, xi_results, lineStyles{j}, 'Color', colors{j}, 'LineWidth', 1.5);
    legend_entries{j} = sprintf('\\alpha = %.1f', alpha);
end
hold off;
grid on;
xlabel('P_S (dB)');
ylabel('ξ');
title('Warden''s Detection Error Probability vs. Source Power');
legend(legend_entries, 'Location', 'best');
axis tight;