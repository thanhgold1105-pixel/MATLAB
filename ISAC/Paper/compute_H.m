function H = compute_H(Ps, Pr, sigma_sr, sigma_rr, sigma_tr, sigma_n, beta, theta, epsilon)

term_D = beta * Pr * sigma_rr^2 + theta * Ps * sigma_tr^2;

term_1 = (Ps * sigma_sr^2) / sigma_n^2;

term_2 = (Ps * sigma_sr^2) / term_D;

inside_W = (sigma_n^2 * exp(sigma_n^2 / term_D)) / ((1 - epsilon) * term_D);

W = lambertw(inside_W);

H = term_1 * W - term_2;

end