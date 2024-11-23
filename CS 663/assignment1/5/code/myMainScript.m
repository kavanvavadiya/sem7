clear; clc;

tic;
%%
im1 = im2double(imread('goi1.jpg'));
im2 = im2double(imread('goi2_downsampled.jpg'));

figure,imagesc(im1); colormap("gray"); axis("equal"); title('Gate Of India (Image 1)');
figure,imagesc(im2); colormap("gray"); axis("equal"); title('Gate Of India (Image 2)');

%%
% Default values for the P1 and P2 matrices
P1 = [
    159   377   374   433   447   458   514   280   140   100    93    93;
    158   164    17   164   223   231   301   260   217   219   154    96;
      1     1     1     1     1     1     1     1     1     1     1     1
];

P2 = [
    194   419   414   476   492   508   573   315   173   129   129   135;
    176   184    35   175   236   247   323   279   238   240   175   120;
      1     1     1     1     1     1     1     1     1     1     1     1
];

%%
% Select the Physically Corresponding points 

% x1 = zeros(12,1);
% x2 = zeros(12,1);

% y1 = zeros(12,1);
% y2 = zeros(12,1);

% for i=1:12
%     figure(1); imshow(im1); [x1(i), y1(i)] = ginput(1);
%     figure(2); imshow(im2); [x2(i), y2(i)] = ginput(1);
% end
% %%

% P1 = [x1'; y1'; ones(size(x1))'];
% P2 = [x2'; y2'; ones(size(x2))'];

%%

A = P2*P1'*inv(P1*P1'); %Ax = y , where x is the pixel in im1 and y is the pixel in im2
%% 

%Reverse warping with nearest neighbour interpolation function  
Warped_Image_nn = NN_Interpolate(im1, im2,A);
figure, imagesc(Warped_Image_nn); colormap("gray"); axis("equal");title("Warped Image using Nearest Neighbour Interpolation");

% Warped_Image_nn = uint8(Warped_Image_nn*255);
% imwrite(Warped_Image_nn,'assignment1\\5\\images\\nn.png');

%Reverse warping with nearest Bilinear interpolation
Warped_Image_Bilinear = Bilinear_Interpolate(im1, im2,A);
figure, imshow(Warped_Image_Bilinear); title("Warped Image using Bilinear Interpolation");

% Warped_Image_Bilinear = uint8(Warped_Image_Bilinear*255);
% imwrite(Warped_Image_Bilinear,'assignment1\\5\\images\\bilinear.png');
toc;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Functions %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function Warped_Image = NN_Interpolate(im1, im2, A) 
% im2 is the target image and im1 is the image that will be rotated
    Warped_Image = zeros(size(im2));
    [X,Y] = meshgrid(1:size(im2,2),1:size(im2,1));
    Destination_Pixels = [X(:)';Y(:)';ones(1,numel(im2))];
    Source_Pixels = inv(A)*Destination_Pixels;             
    Source_Pixels = round(Source_Pixels); % Rounding off to the nearest integer which gives the nearest neighbour pixel in im1

    for i=1:size(Source_Pixels,2)
        if (Source_Pixels(1,i)>0 && Source_Pixels(2,i)>0 && Source_Pixels(1,i)<size(im1,2) && Source_Pixels(2,i)<size(im1,1)) 
            Warped_Image(Destination_Pixels(2,i),Destination_Pixels(1,i)) = im1(Source_Pixels(2,i),Source_Pixels(1,i));
        end
    end
end

function Warped_Image = Bilinear_Interpolate(im1,im2,A)
    Warped_Image = zeros(size(im2));
    [X,Y] = meshgrid(1:size(im2,2),1:size(im2,1));
    Destination_Pixels = [X(:)';Y(:)';ones(1,numel(im2))];
    Source_Pixels = inv(A)*Destination_Pixels;             
    
    for i=1:size(Source_Pixels,2)
        if (Source_Pixels(1,i)>1 && Source_Pixels(2,i)>1 && Source_Pixels(1,i)<(size(im1,2)-1) && Source_Pixels(2,i)<(size(im1,1)-1)) 
            Warped_Image(Destination_Pixels(2,i),Destination_Pixels(1,i)) = Bilinear_method(im1,Source_Pixels(2,i),Source_Pixels(1,i));
        end
    end
end

function z = Bilinear_method(im,y,x)
    x1 = floor(x);
    x2 = x1+1;
    y1 = floor(y);
    y2 = y1+1;
    
    z = im(y1,x1)*(x2-x)*(y2-y) + im(y1,x2)*(x-x1)*(y2-y) + im(y2,x1)*(x2-x)*(y-y1) + im(y2,x2)*(x-x1)*(y-y1);
end