clc; clear; close all;

sigma_n  = 1;
sigma_TR = 1;
sigma_RR = 1;
sigma_SR = 1;

epsilon = 0.1;

P_R_dB = 15;
PR = 10^(P_R_dB/10);

P_S_dB = 15;
PS = 10^(P_S_dB/10);

theta = 0.2;                       % theta cố định

beta_range = logspace(-5, -2, 200);

I_sen = zeros(size(beta_range));

figure; hold on;

for i = 1:length(beta_range)

    beta = beta_range(i);

    % ----- 1) Tính H -----
    H = compute_H(PS, PR, beta, theta, ...
                  sigma_SR, sigma_RR, sigma_TR, sigma_n, epsilon);

    % ----- 2) Xác suất giải mã direct (23) -----
    P_direct = exp( - H * sigma_n^2 / (PS * sigma_SR^2) ) / ...
        ( (1 + H * theta * sigma_TR^2 / sigma_SR^2) * ...
          (1 + H * beta * PR * sigma_RR^2 / (PS * sigma_SR^2)) );

    % ----- 3) I_reflect dạng tích phân ổn định -----
    fun = @(y) (1/log(2)) .* ...
        expint( (y*beta*PR + sigma_n^2) / (theta*PS*sigma_TR^2) ) .* ...
        exp( -(y*beta*PR + sigma_n^2) / (theta*PS*sigma_TR^2) ) .* ...
        (1/(theta*PS*sigma_TR^2)) .* ...
        (1/sigma_RR^2) .* exp(-y/sigma_RR^2);

    I_reflect = integral(fun, 0, Inf, ...
                         'RelTol',1e-6, 'AbsTol',1e-9);

    % ----- 4) I_sen -----
    I_sen(i) = P_direct * I_reflect;

end

semilogx(beta_range, I_sen, 'LineWidth', 2);
xlabel('\beta');
ylabel('I_{sen}');
grid on;
