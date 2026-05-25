function [xq, i] = my_quantizer(x, H, B)

    xmin = -H;
    xmax = H;

    L = 2^B;
    Delta = (xmax - xmin)/L;

    x_clipped = max(min(x, xmax), xmin);

    i = round((x_clipped - xmin)/Delta);

    % Clamp index
    i = max(min(i, L-1), 0);

    xq = xmin + i*Delta;

end