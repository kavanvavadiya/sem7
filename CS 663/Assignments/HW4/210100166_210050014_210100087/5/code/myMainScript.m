clear; close all;
tic;

train_images = [];
test_images = [];
train_labels = [];
test_labels = [];

total_subjects = 32;
train_images_per_subject = 6;

orl_folder_path = "../../ORL/";

for subject_idx = 1:total_subjects
    subject_folder = orl_folder_path + "s" + num2str(subject_idx) + "/";
    image_files = dir(subject_folder + "*.pgm");

    for img_idx = 1:length(image_files)
        img_file_path = fullfile(image_files(img_idx).folder, image_files(img_idx).name);
        image_data = im2double(imread(img_file_path));

        if img_idx <= train_images_per_subject
            train_images = cat(2, train_images, image_data(:));
            train_labels = cat(2, train_labels, subject_idx);
        else
            test_images = cat(2, test_images, image_data(:));
            test_labels = cat(2, test_labels, subject_idx);
        end
    end
end

for subject_idx = 33:40
    image_files = dir(orl_folder_path + "s" + num2str(subject_idx) + "/*.pgm");

    for img_idx = 7:length(image_files)
        img_file_path = fullfile(image_files(img_idx).folder, image_files(img_idx).name);
        image_data = im2double(imread(img_file_path));

        test_images = cat(2, test_images, image_data(:));
        test_labels = cat(2, test_labels, -1);
    end
end

num_train_samples = size(train_images, 2);
num_test_samples = size(test_images, 2);
mean_face = mean(train_images, 2);

train_images_centered = train_images - mean_face;
test_images_centered = test_images - mean_face;

[U, ~, ~] = svd(train_images_centered, 'econ');

k = 75;
eigen_space = U(:, 1:k);

train_coeffs = eigen_space' * train_images_centered;
test_coeffs = eigen_space' * test_images_centered;

threshold_values = linspace(70, 300, 100);
best_recall = 0;
best_threshold = 0;

for threshold = threshold_values
    tp = 0; fp = 0; tn = 0; fn = 0;
    recognition_count = 0;

    for test_idx = 1:num_test_samples
        diff = sum((train_coeffs - test_coeffs(:, test_idx)).^2, 1);
        [min_error, min_index] = min(diff);

        if min_error > threshold
            if test_labels(test_idx) == -1
                tn = tn + 1;
            else
                fn = fn + 1;
            end
        else
            if test_labels(test_idx) == -1
                fp = fp + 1;
            else
                tp = tp + 1;
                if train_labels(min_index) == test_labels(test_idx)
                    recognition_count = recognition_count + 1;
                end
            end
        end
    end

    recall = tp / (tp + fn);
    specificity = tn / (tn + fp);
    accuracy = (tp + tn) / num_test_samples;
    f1_score = tp / (tp + 0.5 * (fp + fn));

    if recall > best_recall
        best_recall = recall;
        best_threshold = threshold;
        best_accuracy = accuracy;
        best_f1_score = f1_score;
        best_specificity = specificity;
        best_recognition_rate = recognition_count / num_test_samples;
        confusion_matrix = [tp, fp; fn, tn];
    end
end

fprintf('Best Threshold: %.2f\n', best_threshold);
fprintf('Accuracy: %.4f\n', best_accuracy);
fprintf('F1 Score: %.4f\n', best_f1_score);
fprintf('Recall: %.4f\n', best_recall);
fprintf('Recognition Rate: %.4f\n', best_recognition_rate);

fprintf('Confusion Matrix:\n');
fprintf('TP: %d\tFP: %d\n', confusion_matrix(1, 1), confusion_matrix(1, 2));
fprintf('FN: %d\tTN: %d\n', confusion_matrix(2, 1), confusion_matrix(2, 2));

toc;
