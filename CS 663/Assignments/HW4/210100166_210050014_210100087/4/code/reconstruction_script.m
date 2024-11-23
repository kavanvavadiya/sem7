clear;
tic;

train_set = [];
test_set = [];
train_sub = [];
test_sub = [];

num_subjects = 32;
train_per_subject = 6;

for index = 1:num_subjects
    % Change this path accourding to ORL Folder present in your system in
    % my case ORL folder in main directory of HW4
    ORL_Folder_Path = "../../ORL/";
    image_files = dir(ORL_Folder_Path + "s" + num2str(index) + "/*.pgm");

    for img_idx = 1:length(image_files)
        img_filename = fullfile(image_files(img_idx).folder, image_files(img_idx).name);
        current_image = im2double(imread(img_filename));

        if img_idx <= train_per_subject
            train_set = cat(2, train_set, current_image(:));
            train_sub = cat(2, train_sub, index);
        else
            test_set = cat(2, test_set, current_image(:));
            test_sub = cat(2, test_sub, index);
        end
    end
end

% specific image to reconstruct, the first image
image = im2double(imread("../../ORL/s1/1.pgm"));
m = size(image, 1); n = size(image, 2);

figure(1);
imagesc(image); colormap("gray"); title("Original image");

%% eigen vectors, eigen coeff, reconstruction

mean_vector = mean(train_set, 2);
X = train_set - mean_vector;

[U, S, V] = svd(X);
k = [2, 10, 20, 50, 75, 100, 125, 150, 175];

for i = 1:length(k)
    eigen_space = U(:, 1:k(i));
    eigen_coef = (eigen_space') * (X(:, 1));
    recon_image = (eigen_space * eigen_coef) + mean_vector;
    recon_image = reshape(recon_image, m, n);
    figure(i + 1);
    imagesc(recon_image); colormap("gray"); title("Reconstructed image for k=" + num2str(k(i)));
end

%% 25 eigen faces

eigen_space = U(:, 1:25);

for i = 1:25
    eigen_face = reshape(eigen_space(:, i), m, n);
    subplot(5, 5, i); imagesc(eigen_face); colormap("gray");
end

toc;
