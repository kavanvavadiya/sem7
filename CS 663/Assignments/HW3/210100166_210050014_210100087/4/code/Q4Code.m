% Define image size and create the image matrix
N = 201;
image = zeros(N, N);

% Set central column to 255
image(:, (N+1)/2) = 255;

% Compute the 2D Fourier transform and shift zero frequency to the center
F = fft2(image);
F_shifted = fftshift(F);

% Compute the logarithm of the magnitude of the Fourier transform
F_magnitude_log = log(abs(F_shifted) + 1); % +1 to avoid log(0)

% Plot the result
figure;
imagesc(F_magnitude_log);
colorbar;
title('Logarithm of Fourier Magnitude');
colormap('jet');
axis image;
