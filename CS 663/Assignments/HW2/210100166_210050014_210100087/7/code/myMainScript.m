%% MyMainScript

tic;
%% Your code here
clear; close all;

Ib = imread('barbara256.png');
Ik = imread('kodak24.png');

figure(1); imagesc(Ib); colormap("gray"); title("Original barbara256");
figure(6); imagesc(Ik); colormap("gray"); title("Original kodak24");

sign = 10;

Ib = im2double(Ib);
Ibn = Ib + sign/255*randn(size(Ib));

Ik = im2double(Ik);
Ikn = Ik + sign/255*randn(size(Ik));

figure(2); imagesc(Ibn); colormap("gray"); title("Noisy barbara256 with \sigma_n = " + num2str(sign));
figure(7); imagesc(Ikn); colormap("gray"); title("Noisy kodak24 with \sigma_n = " + num2str(sign));


sigs1 = 0.1;
sigr1 = 0.1;

sigs2 = 2;
sigr2 = 2;

sigs = 3;
sigr = 15;

sigr = sigr/255;
sigr1 = sigr1/255;
sigr2 = sigr2/255;

BFb1 = mybilateralfilter(Ibn,sigs1,sigr1);
BFb2 = mybilateralfilter(Ibn,sigs2,sigr2);
BFb = mybilateralfilter(Ibn,sigs,sigr);
BFk = mybilateralfilter(Ikn,sigs,sigr);
BFk1 = mybilateralfilter(Ikn,sigs1,sigr1);
BFk2 = mybilateralfilter(Ikn,sigs2,sigr2);

figure(5); imagesc(BFb); colormap("gray"); 
title("filtered barbara256 with \sigma_n = " + num2str(sign) + ", \sigma_s = " + num2str(sigs) + ", \sigma_r = " + num2str(sigr*255));
figure(3); imagesc(BFb1); colormap("gray"); 
title("filtered barbara256 with \sigma_n = " + num2str(sign) + ", \sigma_s = " + num2str(sigs1) + ", \sigma_r = " + num2str(sigr1*255));
figure(4); imagesc(BFb2); colormap("gray"); 
title("filtered barbara256 with \sigma_n = " + num2str(sign) + ", \sigma_s = " + num2str(sigs2) + ", \sigma_r = " + num2str(sigr2*255));
figure(10); imagesc(BFk); colormap("gray");
title("filtered kodak24 with \sigma_n = " + num2str(sign) + ", \sigma_s = " + num2str(sigs) + ", \sigma_r = " + num2str(sigr*255));
figure(8); imagesc(BFk1); colormap("gray");
title("filtered kodak24 with \sigma_n = " + num2str(sign) + ", \sigma_s = " + num2str(sigs1) + ", \sigma_r = " + num2str(sigr1*255));
figure(9); imagesc(BFk2); colormap("gray");
title("filtered kodak24 with \sigma_n = " + num2str(sign) + ", \sigma_s = " + num2str(sigs2) + ", \sigma_r = " + num2str(sigr2*255));

toc;
