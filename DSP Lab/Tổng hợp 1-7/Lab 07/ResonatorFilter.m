function [b,a] = ResonatorFilter(fs,f0,delta_f)

% Normalized frequencies

w0 = 2*pi*f0/fs;

delta_w = 2*pi*delta_f/fs;

% Resonator parameter

R = 1 - delta_w/2;

% Filter coefficients

a1 = -2*R*cos(w0);

a2 = R^2;

G = (1-R)*sqrt(1 - 2*R*cos(2*w0) + R^2);

% Transfer function coefficients

b = [G];

a = [1 a1 a2];

end