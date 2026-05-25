function y = quantized_example(x, R, B)

    xmin = -R/2;
    xmax = R/2;

    L = 2^B;
    Delta = (xmax - xmin)/L;

    x_clipped = max(min(x, xmax), xmin);

    i = round((x_clipped - xmin)/Delta);
    i = max(min(i, L-1), 0);

    y = xmin + i*Delta;

end