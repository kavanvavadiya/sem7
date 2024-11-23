% Face Recognition of Yale Face Database using eigs

clear; close all;

tic;

train_set = [];
train_sub = [];
test_set = [];
test_sub = [];

for i = [1:13, 15:39]
    % Change this path accourding to ORL Folder present in your system in
    % my case YALE folder in main directory of HW4
    Yale_Folder_Path = "../../CroppedYale/";
    image_files = dir(Yale_Folder_Path + "yaleB" + num2str(i, '%02d') + "/*.pgm");

    for img_idx = 1:length(image_files)
        img_filename = fullfile(image_files(img_idx).folder, image_files(img_idx).name);
        current_image = im2double(imread(img_filename));

        if (img_idx <= 40)
            train_set = cat(2, train_set, current_image(:));
            train_sub = cat(2, train_sub, i);
        else
            test_set = cat(2, test_set, current_image(:));
            test_sub = cat(2, test_sub, i);
        end
    end
end
k = [1, 2, 3, 5, 10, 15, 20, 30, 50, 60, 65, 75, 100, 200, 300, 500, 1000];
recognition_rate_for_all = face_recognition(train_set, train_sub, test_set, test_sub, k);
recognition_rate_for_other = face_recognition1(train_set, train_sub, test_set, test_sub, k);

figure(1);plot(k, recognition_rate_for_all, 'o-');
figure(2); plot(k, recognition_rate_for_other, 'o-');

toc;

%% Functions

function recognition_rate = face_recognition(train_set, train_sub, test_set, test_sub, k)
    mean_vector = mean(train_set, 2);
    X = train_set - mean_vector;
    Y = test_set - mean_vector;
    n_test = size(test_set, 2);

    L = X' * X;
    [V, D] = eigs(L, k(end));
    U = X * V;  
    U = U ./ vecnorm(U);  % Normalize the eigenfaces

    recognition_rate = zeros(size(k));

    for i = 1:length(k)
        eigen_space = U(:, 1:k(i));
        eigen_coef = (eigen_space') * X;
        test_coef = (eigen_space') * Y;
        recognition_count = 0;

        for j = 1:n_test
            [m, index] = min(sum((eigen_coef - test_coef(:, j)).^2));

            if train_sub(index) == test_sub(j)
                recognition_count = recognition_count + 1;
            end
        end

        recognition_rate(i) = recognition_count / n_test;
    end
end

% Face recognition function ignoring top 3 eigenvectors using eigs
function recognition_rate = face_recognition1(train_set, train_sub, test_set, test_sub, k)
    mean_vector = mean(train_set, 2);
    X = train_set - mean_vector;
    Y = test_set - mean_vector;
    n_test = size(test_set, 2);

    L = X' * X;
    [V, D] = eigs(L, k(end));
    U = X * V;  
    U = U ./ vecnorm(U);  % Normalize the eigenfaces

    recognition_rate = zeros(size(k));

    for i = 1:length(k)
        eigen_space = U(:, 1:k(i));
        eigen_coef = (eigen_space') * X;
        eigen_coef = eigen_coef(4:end, :);  % Ignore the top 3 eigenvalues
        test_coef = (eigen_space') * Y;
        test_coef = test_coef(4:end, :);  % Ignore the top 3 eigenvalues
        recognition_count = 0;

        for j = 1:n_test
            [m, index] = min(sum((eigen_coef - test_coef(:, j)).^2));

            if train_sub(index) == test_sub(j)
                recognition_count = recognition_count + 1;
            end
        end

        recognition_rate(i) = recognition_count / n_test;
    end
end
