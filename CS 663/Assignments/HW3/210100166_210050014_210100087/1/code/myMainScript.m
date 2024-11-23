%% Main Script

tic;
clear; close all; clc;

% Specify the folder where images will be saved
output_folder = 'filtered_images';
if ~exist(output_folder, 'dir')
    mkdir(output_folder); % Create the folder if it doesn't exist
end

img = im2double(imread('barbara256.png'));
figure; imshow(img, 'Colormap', gray); title('Original Image');
saveImage(output_folder, 'Original_Image', img);

padded_img = padarray(img, [size(img, 1) / 2, size(img, 2) / 2]);

% Apply Ideal Low Pass Filter and save results
filtered_ideal = applyIdealLowPassFilter(padded_img, 80, output_folder);
filtered_ideal = extractCenter(filtered_ideal, size(img));
figure; imshow(filtered_ideal, 'Colormap', gray);
saveImage(output_folder, 'Filtered_Ideal_LowPass', filtered_ideal);

% Apply Gaussian Low Pass Filter and save results
filtered_gaussian = applyGaussianLowPassFilter(padded_img, 80, output_folder);
filtered_gaussian = extractCenter(filtered_gaussian, size(img));
figure; imshow(filtered_gaussian, 'Colormap', gray);
saveImage(output_folder, 'Filtered_Gaussian_LowPass', filtered_gaussian);

toc;

% Function to extract the center of the filtered image
function center_img = extractCenter(filtered_img, original_size)
    h = original_size(1); w = original_size(2);
    center_img = filtered_img(h/2+1:h/2+h, w/2+1:w/2+w);
end

% Ideal Low Pass Filter Function with saving options
function filtered_img = applyIdealLowPassFilter(img, cutoff, output_folder)
    F = fftshift(fft2(img));
    displayFourier(F, 'Fourier Transform of Original Image', output_folder, 'Fourier_Original_Image');

    [rows, cols] = size(F);
    [x, y] = meshgrid(-rows/2:rows/2-1, -cols/2:cols/2-1);
    filter_mask = (x.^2 + y.^2) <= cutoff^2;
    displayFilter(filter_mask, 'Ideal Low Pass Filter', output_folder, 'Ideal_LowPass_Filter');

    F_filtered = F .* filter_mask;
    displayFourier(F_filtered, 'Filtered Fourier Transform (Ideal)', output_folder, 'Fourier_Filtered_Ideal');
    filtered_img = ifft2(ifftshift(F_filtered));
end

% Gaussian Low Pass Filter Function with saving options
function filtered_img = applyGaussianLowPassFilter(img, sigma, output_folder)
    F = fftshift(fft2(img));

    [rows, cols] = size(F);
    [x, y] = meshgrid(-rows/2:rows/2-1, -cols/2:cols/2-1);
    gaussian_filter = exp(-((x.^2 + y.^2) / (2 * sigma^2)));
    displayFilter(gaussian_filter, 'Gaussian Low Pass Filter', output_folder, 'Gaussian_LowPass_Filter');

    F_filtered = F .* gaussian_filter;
    displayFourier(F_filtered, 'Filtered Fourier Transform (Gaussian)', output_folder, 'Fourier_Filtered_Gaussian');
    filtered_img = ifft2(ifftshift(F_filtered));
end

% Utility to display and save Fourier Transforms
function displayFourier(F, title_text, output_folder, filename)
    log_F = log(abs(F) + 1);
    figure; imshow(log_F, []); colormap('jet'); colorbar; title(title_text);
    saveImage(output_folder, filename, log_F);
end

% Utility to display and save Filters
function displayFilter(filter, title_text, output_folder, filename)
    log_filter = log(1 + filter);
    figure; imshow(log_filter, []); colormap('jet'); colorbar; title(title_text);
    saveImage(output_folder, filename, log_filter);
end

% Function to save images to a folder
function saveImage(folder, name, img)
    filepath = fullfile(folder, [name, '.png']);
    imwrite(img, filepath);
end
