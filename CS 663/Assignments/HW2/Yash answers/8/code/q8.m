img1= imread('barbara256.png');
img2= imread('kodak24.png');
img1=double(img1);
img2=double(img2);
noise1 = random('normal', 0, 5, size(img1));
noise2 = random('normal', 0, 5, size(img2));
noisy_img1= img1+noise1;
noisy_img2=img2+noise2;
inputs = [2,2;0.1,0.1;3,15];
denoised_img1 = zeros(256,256,3);
denoised_img2 = zeros(512,768,3);
for i=1:3
    denoised_img1(:,:,i) = mybilateralfilter(noisy_img1,inputs(i,1),inputs(i,2));
    figure(i)
    imshow(denoised_img1(:,:,i),[])
end
for i=1:3
    denoised_img2(:,:,i) = mybilateralfilter(noisy_img2,inputs(i,1),inputs(i,2));
    figure(3+i)
    imshow(denoised_img2(:,:,i),[])
end
noise3 = random('normal', 0, 10, size(img1));
noise4 = random('normal', 0, 10, size(img2));
noisy_img3= img1+noise3;
noisy_img4=img2+noise4;
denoised_img3 = zeros(256,256,3);
denoised_img4 = zeros(512,768,3);
for i=1:3
    denoised_img3(:,:,i) = mybilateralfilter(noisy_img3,inputs(i,1),inputs(i,2));
    figure(6+i)
    imshow(denoised_img3(:,:,i),[])
end
for i=1:3
    denoised_img4(:,:,i) = mybilateralfilter(noisy_img4,inputs(i,1),inputs(i,2));
    figure(9+i)
    imshow(denoised_img4(:,:,i),[])
end
figure(13)
imshow(noisy_img1,[])
figure(14)
imshow(noisy_img2,[])
figure(15)
imshow(noisy_img3,[])
figure(16)
imshow(noisy_img4,[])
% imwrite(denoised_img1(:,:,1)/255,'C:\Users\risha\OneDrive\Documents\MATLAB\CS663\assignment2\bar_5_1.jpeg')
% imwrite(denoised_img1(:,:,2)/255,'C:\Users\risha\OneDrive\Documents\MATLAB\CS663\assignment2\bar_5_2.jpeg')
% imwrite(denoised_img1(:,:,3)/255,'C:\Users\risha\OneDrive\Documents\MATLAB\CS663\assignment2\bar_5_3.jpeg')
% imwrite(denoised_img2(:,:,1)/255,'C:\Users\risha\OneDrive\Documents\MATLAB\CS663\assignment2\kod_5_1.jpeg')
% imwrite(denoised_img2(:,:,2)/255,'C:\Users\risha\OneDrive\Documents\MATLAB\CS663\assignment2\kod_5_2.jpeg')
% imwrite(denoised_img2(:,:,3)/255,'C:\Users\risha\OneDrive\Documents\MATLAB\CS663\assignment2\kod_5_3.jpeg')
% imwrite(denoised_img3(:,:,1)/255,'C:\Users\risha\OneDrive\Documents\MATLAB\CS663\assignment2\bar_10_1.jpeg')
% imwrite(denoised_img3(:,:,2)/255,'C:\Users\risha\OneDrive\Documents\MATLAB\CS663\assignment2\bar_10_2.jpeg')
% imwrite(denoised_img3(:,:,3)/255,'C:\Users\risha\OneDrive\Documents\MATLAB\CS663\assignment2\bar_10_3.jpeg')
% imwrite(denoised_img4(:,:,1)/255,'C:\Users\risha\OneDrive\Documents\MATLAB\CS663\assignment2\kod_10_1.jpeg')
% imwrite(denoised_img4(:,:,2)/255,'C:\Users\risha\OneDrive\Documents\MATLAB\CS663\assignment2\kod_10_2.jpeg')
% imwrite(denoised_img4(:,:,3)/255,'C:\Users\risha\OneDrive\Documents\MATLAB\CS663\assignment2\kod_10_3.jpeg')
% imwrite(noisy_img1/255,'C:\Users\risha\OneDrive\Documents\MATLAB\CS663\assignment2\bar_noisy_5.jpeg')
% imwrite(noisy_img2/255,'C:\Users\risha\OneDrive\Documents\MATLAB\CS663\assignment2\kod_noisy_5.jpeg')
% imwrite(noisy_img3/255,'C:\Users\risha\OneDrive\Documents\MATLAB\CS663\assignment2\bar_noisy_10.jpeg')
% imwrite(noisy_img4/255,'C:\Users\risha\OneDrive\Documents\MATLAB\CS663\assignment2\kod_noisy_10.jpeg')
