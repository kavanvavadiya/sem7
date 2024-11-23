% Face Recognition of ORL Database

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

n_train = size(train_set, 2);
n_test = size(test_set, 2);
mean_vector = mean(train_set, 2);

X = train_set - mean_vector;
Y = test_set - mean_vector;

% Using eig function
L = X' * X;
[V, D] = eig(L, 'vector');
[D, sorted_indices] = sort(D, 'descend');
V = V(:, sorted_indices);
U = X * V;

% SVD: Obtain eigenfaces
% [U, S, V] = svd(X, 'econ');  % 'econ' to compute the economy-sized decomposition

U = U ./ vecnorm(U); % Normalize the columns of U
k_values = [1, 2, 3, 5, 10, 15, 20, 30, 50, 75, 100, 150, 170];
rate_of_recognition = zeros(size(k_values));

for k_idx = 1:length(k_values)
    k = k_values(k_idx);
    eigen_space = U(:, 1:k);
    eigen_coef_train = eigen_space' * X;
    eigen_coef_test = eigen_space' * Y;
    
    count = 0;
    
    for test_idx = 1:n_test
        distances = sum((eigen_coef_train - eigen_coef_test(:, test_idx)).^2);
        [~, closest_img_idx] = min(distances);

        if train_sub(closest_img_idx) == test_sub(test_idx)
            count = count + 1;
        end
    end
    
    rate_of_recognition(k_idx) = count / n_test;
end

figure;
plot(k_values, rate_of_recognition, 'o-', 'LineWidth', 1.5);
xlabel('Number of Eigenfaces (k)', 'FontSize', 15);
ylabel('Recognition Rate', 'FontSize', 15);
title('Recognition Rate vs Number of Eigenfaces (using eig function)', 'FontSize', 10);
grid on;

toc;
