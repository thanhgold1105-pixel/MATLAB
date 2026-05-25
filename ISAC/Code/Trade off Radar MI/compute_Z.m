function Z = compute_Z(PS, PR, beta, theta, sigma_SR2, sigma_RR2, sigma_TR2, sigma_n2, epsilon)

    denom = beta .* PR .* sigma_RR2 + theta .* PS .* sigma_TR2;
    denom = max(denom, eps);   % ổn định số

    arg = (sigma_n2 .* exp(sigma_n2 ./ denom)) ./ ((1 - epsilon) .* denom);
    arg(arg < -1/exp(1)) = NaN;

    Z = (PS .* sigma_SR2 ./ sigma_n2) .* lambertw(0, arg) - (PS .* sigma_SR2) ./ denom;

    Z(Z < 0) = 0;
end
