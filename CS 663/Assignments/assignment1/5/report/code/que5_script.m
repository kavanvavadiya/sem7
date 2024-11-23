J1 = imread("T1.jpg");
J2 = imread("T2.jpg");

% Rotating J2 by 28.5 degrees anticlockwise using nearest neighbour interpolation
J3 = imrotate(J2, 28.5, "nearest", "crop");

% theta ranges from -45 to 45 with interval 1 degree
thetas = -45:1:45;

NCC_values = zeros(length(thetas), 1);
JE_values = zeros(length(thetas), 1);
QMI_values = zeros(length(thetas), 1);

for i = 1:length(thetas)
    theta = thetas(i);
    J4 = imrotate(J3, theta, "nearest", "crop");
    NCC_values(i) = NCC(J1, J4);
    JE_values(i) = JE(J1, J4);
    QMI_values(i) = QMI(J1, J4);
end

% NCC Plot
plot(thetas, NCC_values);
title('NCC between J1 and J4');
xlabel('Theta');
ylabel('Normalized Cross Correlation');
saveas(gcf,'NCC','png');

% JE Plot
plot(thetas, JE_values);
title('JE between J1 and J4');
xlabel('Theta');
ylabel('Joint Entropy');
saveas(gcf,'JE','png');

% QMI Plot
plot(thetas, QMI_values);
title('QMI between J1 and J4');
xlabel('Theta');
ylabel('Quadratic Mutual Information');
saveas(gcf,'QMI','png');

optimal_angle = -29.0;
J5 = imrotate(J3, optimal_angle, "nearest", "crop");
optimal_JE_hist = norm_joint_histogram(J1, J5, 10);
imagesc(optimal_JE_hist);

toc;

% Computes the normalized cross correlation for two images
function normalized_cross_correlation = NCC(I1, I2)
    % Compute mean of both the images
    mean_I1 = mean(I1, "all");
    mean_I2 = mean(I2, "all");
    
    % Compute dot product of (I1 - mean_I1) and (I2 - mean_I2)
    num = sum((I1 - mean_I1).*(I2 - mean_I2), "all");
    den = sqrt(sum((I1 - mean_I1).^2, "all") * sum((I2 - mean_I2).^2, "all"));
    normalized_cross_correlation = abs(num/den);
end

% Computes the normalized 2d joint histogram of images I1 and I2
function norm_joint_hist = norm_joint_histogram(I1, I2, bin_width)
    bins = ceil(256/bin_width) + 1;
    % I1 and I2 should be of the same size
    N = size(I1, 1);
    M = size(I2, 2);
    joint_hist = zeros(bins, bins);
    
    % Increment the pixel count in joint_hist for intensities corresponding to each
    % spatial location
    for r = 1:N
        for c = 1:M
            % Intesity bin for img 1
            i1 = floor(I1(r, c)/bin_width) + 1;
            % Intesity bin for img 2
            i2 = floor(I2(r, c)/bin_width) + 1;
            joint_hist(i1, i2) = joint_hist(i1, i2) + 1;
        end
    end

    % Normalize the 2d joint histogram
    norm_joint_hist = joint_hist/(N*M);

end

% Computes the joint entropy of images I1 and I2
function joint_entropy = JE(I1, I2)
    % Compute the normalized joint histogram of images I1 and I2
    norm_joint_hist = norm_joint_histogram(I1, I2, 10);
    % Calculate the shannon entropy using norm_joint_hist
    shannon_entropy = norm_joint_hist .* log2(norm_joint_hist);
    % Set NaN values resulting from 0 * INF computation to 0
    shannon_entropy(isnan(shannon_entropy)) = 0;
    % Compute the joint entropy of I1 and I2
    joint_entropy = -1 * sum(shannon_entropy, "all");
end

% Computes the quadratic mutual information of images I1 and I2
function quadratic_mutual_information = QMI(I1, I2)
    % Compute the normalized joint histogram of images I1 and I2
    norm_joint_hist = norm_joint_histogram(I1, I2, 10);
    Pi1 = sum(norm_joint_hist, 2);
    Pi2 = sum(norm_joint_hist, 1);

    quadratic_mutual_information = sum((norm_joint_hist - Pi1 * Pi2).^2, "all");
end