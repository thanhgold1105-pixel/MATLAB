clc; clear; close all;

%% 1. Original "analog" signal (giả lập)
fs_analog = 100000;              % rất cao → coi như liên tục
t = 0:1/fs_analog:10;            % 10 giây

x = cos(2*pi*261.63*t) + ...
    cos(2*pi*329.63*t) + ...
    cos(2*pi*392.00*t);          % hợp âm C

x = x / max(abs(x));

%% 2. Sampling
fs = 8000;                       % sampling frequency
Ts = 1/fs;
n = 0:Ts:10;

xs = cos(2*pi*261.63*n) + ...
     cos(2*pi*329.63*n) + ...
     cos(2*pi*392.00*n);

xs = xs / max(abs(xs));

%% 3. Quantization function
quantize = @(x, B) round(x * (2^(B-1)-1)) / (2^(B-1)-1);

B_list = [2 3 4 10];

%% 4. Reconstruction (interpolation)
for i = 1:length(B_list)
    B = B_list(i);
    
    % Quantize
    xq = quantize(xs, B);
    
    % Reconstruct (linear interpolation)
    xr = interp1(n, xq, t, 'linear');
    xr(isnan(xr)) = 0;
    
    % Normalize
    xr = xr / max(abs(xr));
    
    % Play sound
    fprintf('Playing %d-bit...\n', B);
    sound(xr, fs_analog);
    pause(12); % đợi nghe xong
    
    % Plot
    figure;
    plot(t(1:2000), x(1:2000), 'b'); hold on;
    plot(t(1:2000), xr(1:2000), 'r--');
    legend('Original', sprintf('%d-bit Reconstructed', B));
    title(['Reconstruction with ', num2str(B), '-bit']);
end