%% Assignment 1, Solution 5

clc; clear; tic;

% Reading images from the main dir and casting them to double precision
im1 = imread("../../../goi1.jpg");
im1 = im2double(im1);
im2 = imread("../../../goi2_downsampled.jpg");
im2 = im2double(im2);

% Selecting 12 pairs of physically corresponding salient feature points from both the images
N = 12;
x1 = zeros(N, 1); y1 = zeros(N, 1);
x2 = zeros(N, 1); y2 = zeros(N, 1);
for i = 1:N
    figure(1); imshow(im1); [x1(i), y1(i)] = ginput(1);
    figure(2); imshow(im2); [x2(i), y2(i)] = ginput(1);
end

% Solving for the affine transformation matrix A
Ar1 = linsolve([x1, y1, ones(N, 1)], x2)';
Ar2 = linsolve([x1, y1, ones(N, 1)], y2)';
Ar3 = [0, 0, 1];
A = [Ar1; Ar2; Ar3];

% Initializing variables for interpolation
N = size(im2, 1);
M = size(im2, 2);
im3 = zeros(N, M);
im4 = zeros(N, M);

for y = 1:N
    for x = 1:M
        % Reverse warping the destination image coordinates (x, y)
        ro = A\[x; y; 1];
        xo = ro(1); yo = ro(2);

        % Nearest Neighbour Interpolation of (xo, yo)
        xi = clip(round(xo), 1, M); yi = clip(round(yo), 1, N);
        im3(y, x) = im1(yi, xi);

        % Bilinear Interpolation of (xo, yo)
        x1 = clip(floor(xo), 1, M); x2 = clip(ceil(xo), 1, M);
        y1 = clip(floor(yo), 1, N); y2 = clip(ceil(yo), 1, N);

        if x1 ~= x2 && y1 ~= y2
            fy1 = (x2 - xo)*im1(y1, x1)/(x2 - x1) + (xo - x1)*im1(y1, x2)/(x2 - x1);
            fy2 = (x2 - xo)*im1(y2, x1)/(x2 - x1) + (xo - x1)*im1(y2, x2)/(x2 - x1);
            fx = (y2 - yo) * fy1/(y2 - y1) + (yo - y1) * fy2/(y2 - y1);
            im4(y, x) = fx;
        elseif x1 == x2 && y1 ~= y2
            im4(y, x) = (y2 - yo) * im1(y1, x1)/(y2 - y1) + (yo - y1) * im1(y2, x1)/(y2 - y1);
        elseif x1 ~= x2 && y1 == y2
            im4(y, x) = (x2 - xo) * im1(y1, x1)/(x2 - x1) + (xo - x1) * im1(y1, x2)/(x2 - x1);
        else
            im4(y, x) = im1(y1, x1);
        end

    end
end

% Saving the nearest neighbour interpolation
imwrite(im3, "../images/NNI.png");
% Saving the bilinear interpolation
imwrite(im4, "../images/BI.png");

toc;

% Clip an input value so that it lies in the range of [min, max]
function u_clip = clip(u, min, max)
    if u > max
        u_clip = max;
    elseif u < min
        u_clip = min;
    else
        u_clip = u;
    end
end