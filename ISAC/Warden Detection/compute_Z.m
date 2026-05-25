function Z = compute_Z(sigma_sr, sigma_rr, sigma_tr, sigma_n, epsilon, beta, theta, Pr, Ps)

main_numer = Ps * sigma_sr^2 ;
main_denom = beta * Pr * sigma_rr^2 + theta * Ps * sigma_tr^2 ;

% Lambert argument
main_exp = exp(sigma_n^2 / main_denom);
numer_lambert = sigma_n^2 * main_exp;
denom_lambert = (1 - epsilon) * main_denom;
in_lambert = numer_lambert / denom_lambert;

W = lambertw(0, in_lambert);   % principal branch

% Terms
term_1 = main_numer/sigma_n^2;
term_2 = main_numer/main_denom;

% Final result
Z = term_1 * W - term_2;

end