function I = compute_I_reflect(Ps, Pr, sigma_TR2, sigma_RR2, sigma_n2, beta, theta)

kappa  = sigma_n2 / (theta * Ps * sigma_TR2);
lambda = sigma_n2 / (beta  * Pr * sigma_RR2);

numer = exp(kappa) * expint(kappa) - exp(lambda) * expint(lambda);

denom = (beta * Pr * sigma_RR2) / (theta * Ps * sigma_TR2) - 1;

% ---- xử lý trường hợp suy biến ----
if abs(denom) < 1e-12
    I = (1/log(2)) * (1 - kappa * exp(kappa) * expint(kappa));
    I = max(I, 0);        % MI không âm
    return;
end

% ---- bản an toàn ----
I = (1/log(2)) * numer / abs(denom);

% Mutual information không thể âm
I = max(I, 0);

end
