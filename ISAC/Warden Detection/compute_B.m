function B = compute_B(Ps, sigma_ss, sigma_n, epsilon, beta)

% Common denominator
denom = beta * Ps * sigma_ss^2;

% Lambert argument
exp_term = exp(sigma_n^2 / denom);

numer_lambert = sigma_n^2 * exp_term;

denom_lambert = (1 - epsilon) * denom;

in_lambert = numer_lambert / denom_lambert;

% Principal branch W0
W = lambertw(0, in_lambert);

% Final expression
B = W - (sigma_n^2 / denom);

end
