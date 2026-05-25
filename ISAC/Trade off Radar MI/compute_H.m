function H = compute_H(PS, PR, beta, theta, sigma_SR, sigma_RR, sigma_TR, sigma_n, epsilon)

term_1 = beta * PR * sigma_RR^2 + theta * PS * sigma_TR^2;
term_2 = sigma_n^2 * exp( sigma_n^2 / term_1 );
term_3 = (1 - epsilon) * term_1;
term_4 = term_2 / term_3;

H = (PS * sigma_SR^2) / term_1 * ( lambertw(0, term_4) - 1 );

end
