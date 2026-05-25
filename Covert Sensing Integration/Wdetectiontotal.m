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


