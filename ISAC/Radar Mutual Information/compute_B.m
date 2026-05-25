function B = compute_B(Ps, sigma_SS2, sigma_n2, beta, epsilon)
% Denominator term
term_D = beta * Ps * sigma_SS2;

% Argument inside Lambert W
inside_W = (sigma_n2 / ((1 - epsilon) * term_D)) * exp(sigma_n2 / term_D);

% Compute B
B = lambertw(0, inside_W) - sigma_n2 / term_D;

end