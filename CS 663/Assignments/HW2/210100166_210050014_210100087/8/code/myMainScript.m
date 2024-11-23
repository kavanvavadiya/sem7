%% Main Script

tic;

clc;
clear;
close all;

%% Load Images
LC_1 = im2double(imread('LC1.png'));
LC_2 = im2double(imread('LC2.jpg'));

figure(1); 
imagesc(LC_1); 
colormap('gray'); 
title('Original Image LC1'); 
impixelinfo;

figure(2); 
imagesc(LC_2); 
colormap('gray'); 
title('Original Image LC2'); 
impixelinfo; 

%% Local Histogram Equalization
sizes = [7, 31, 51, 71];

for i = 1:numel(sizes)
    N = sizes(i);
    
    LC_1_eqn = local_hist_eq(LC_1, N);
    LC_2_eqn = local_hist_eq(LC_2, N);
    
    figure(2*i+1); 
    imagesc(LC_1_eqn); 
    colormap('gray'); 
    title(sprintf('LC1 Local Histogram Equalization with Size %d', N)); 
    impixelinfo;
    
    figure(2*i+2); 
    imagesc(LC_2_eqn); 
    colormap('gray'); 
    title(sprintf('LC2 Local Histogram Equalization with Size %d', N)); 
    impixelinfo;
end

%% Global Histogram Equalization
LC_1_global = histeq(uint8(255 * LC_1));
imwrite(LC_1_global, 'LC1_global.png');

LC_2_global = histeq(uint8(255 * LC_2));
imwrite(LC_2_global, 'LC2_global.png');

toc;

%% Local Histogram Equalization Function
function I_eq = local_hist_eq(I, N)
    [m, n] = size(I);
    ps = floor(N / 2);
    I_pad = padarray(I, [ps, ps], 'replicate');
    I_eq = zeros(m, n);

    for i = 1:m
        for j = 1:n
            local_region = I_pad(i:i+N-1, j:j+N-1);
            LH = compute_local_hist(local_region, N);
            r = floor(I(i, j) * 255) + 1;
            I_eq(i, j) = round(255 * sum(LH(1:r)));
        end
    end
end

%% Compute Local Histogram Function
function p_r = compute_local_hist(I, N)
    bin_ind = floor(I * 255) + 1;
    p_r = accumarray(bin_ind(:), 1, [256, 1]);
    p_r = p_r / (N * N);
end
