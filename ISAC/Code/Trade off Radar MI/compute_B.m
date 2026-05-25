function B = compute_B(PS, beta, sigma_SS2, sigma_n2, epsilon)

    % Denominator
    D = beta .* PS .* sigma_SS2;
    D = max(D, eps);   % tránh chia 0 / overflow

    % Lambert-W argument
    arg = (sigma_n2 ./ ((1 - epsilon) .* D)) .* exp(sigma_n2 ./ D);

    % Miền xác định của W0
    arg(arg < -1/exp(1)) = NaN;

    % Tính B
    B = lambertw(0, arg) - sigma_n2 ./ D;

    % Ý nghĩa vật lý
    B(B < 0) = 0;
end
