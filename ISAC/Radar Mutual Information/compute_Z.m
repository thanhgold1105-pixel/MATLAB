function Z = compute_Z(Ps, Pr, sigma_SR2, sigma_RR2, sigma_TR2, sigma_n2, beta, theta, epsilon)
    % Common denominator term
    term_D = beta * Pr * sigma_RR2 + theta * Ps * sigma_TR2;

    if term_D <= 0
        error('Denominator D must be positive');
    end

    % Argument inside Lambert W
    inside_W = ( sigma_n2 * exp(sigma_n2 / term_D) ) ...
               / ( (1 - epsilon) * term_D );

    % Main expression
    Z = (Ps * sigma_SR2 / sigma_n2) * lambertw(0, inside_W) ...
        - (Ps * sigma_SR2) / term_D;

end
