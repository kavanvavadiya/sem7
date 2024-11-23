%% MyMainScript

tic;
%% Your code here
clear; clc;

J1 = im2double(imread('T1.jpg'));
J2 = im2double(imread('T2.jpg'));
J3 = imrotate(J2,28.5,'crop');

theta=-45:1:45;
NCC = zeros(1,length(theta)); JE = zeros(1,length(theta)); QMI = zeros(1,length(theta));
BW = 10;
for i=1:length(theta)
    J4 = imrotate(J3+1,theta(i),'crop');             % add 1 to J3 to remeber the valid pixels
    J4c = J4-1; b = J4c~=-1; J1c=J1(b); J4c=J4c(b);  % collect only the valid pixels, J1c and J4c are column arrays
    JH = compute_JH2(J1c,J4c,BW);                    % compute joint histogram
    NCC(i) = compute_NCC(J1c,J4c);                   % compute normalised cross correlation
    JE(i) = compute_JE(JH);                          % compute joint entropy
    QMI(i) = compute_QMI(JH);                        % compute quadrature mutual information
end

figure(1); plot(theta, NCC); xlabel('theta'); ylabel('NCC'); title('Normalised Cross Correlation'); grid on;
figure(2); plot(theta, JE); xlabel('theta'); ylabel('JE'); title('Joint Entropy'); grid on;
figure(3); plot(theta, QMI); xlabel('theta'); ylabel('QMI'); title('Quadrature Mutual Information'); grid on;

[m,ind] = min(JE);
J4 = imrotate(J3+1,theta(ind),'crop');
J4c = J4-1; b = J4c~=-1; J1c=J1(b); J4c=J4c(b);  
JH = compute_JH2(J1c,J4c,BW);
figure(4); imagesc(0:BW:255,0:BW:255,JH); colorbar; xlabel('J4'); ylabel('J1'); title('Joint Histogram for minimum JE with bin width 10');

figure(5); imshow(J1); title('image 1');
figure(6); imshow(J2); title('image 2');
figure(7); imshow(J3); title('rotated image 2 by 28.5 degrees anti-clockwise');
figure(8); imshow(J4-1); title('aligned rotated image 2 wrt image 1');
toc;

%%

%%%%%%%%%%%%%
% functions %
%%%%%%%%%%%%%

function NCC = compute_NCC(J1,J2)
    J1m = mean(J1,'all');
    J2m = mean(J2,'all');
    num = sum((J1-J1m).*(J2-J2m),'all');
    den = sqrt(sum((J1-J1m).^2,'all')*sum((J2-J2m).^2,'all'));
    NCC = abs(num/den);
end

function JE = compute_JE(JH)
    b = JH~=0;
    JE = -1*(sum(JH(b).*log2(JH(b)),'all'));
end

function QMI = compute_QMI(JH)
    H1 = sum(JH,2); H2 = sum(JH);
    QMI = sum((JH-H1*H2).^2,'all');
end

function JH = compute_JH1(J1,J2,BW) % row bin is of J1, column bin is of J2
    bins = ceil(255/BW);
    binJ1 = floor(J1.*(255/BW))+1;
    binJ2 = floor(J2.*(255/BW))+1;
    JH = zeros(bins);
    for i=1:26
        b1 = binJ1==i;
        for j=1:26
            b2 = binJ2==j;
            b = and(b1,b2);
            JH(i,j) = sum(b,'all');
        end
    end
    JH = JH./(length(J1(:)));
end

function JH = compute_JH2(J1,J2,BW)
    binJ1 = floor(J1*(255/BW))+1;
    binJ2 = floor(J2*(255/BW))+1;
    binJ = [binJ1(:) binJ2(:)];
    JH = accumarray(binJ,ones(1,length(J1(:))));
    JH = JH./(length(J1(:)));
end
