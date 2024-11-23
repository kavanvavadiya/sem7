im1 = imread("goi1.jpg");
im2 = imread("goi2.jpg");

% imshow(im1);
% imshow(im2);

x1 = zeros(12,1);
y1 = zeros(12,1);
x2 = zeros(12,1);
y2 = zeros(12,1);


% for i=1:12
%     figure(1);
%     imshow(im1);
%     [x1(i), y1(i)] = ginput(1);
%     figure(2);
%     imshow(im2);
%     [x2(i), y2(i)] = ginput(1);
% end
x1 = [281;180;120;504;373;130;517;239;100;452;572;97];
x2 = [312;214;152;557;414;168;573;289;131;498;637;127;];
y1 = [254;217;236;246;17;42;299;313;298;291;172;335];
y2 = [273;240;255;262;31;66;320;335;320;311;183;357;];
%%
lhs = [x2';y2';ones(1,12)];
rhs = [x1';y1';ones(1,12)];
psedo_inv = rhs'/(rhs*rhs');
affine = lhs*psedo_inv;
%%
im3 = ones(360,640);
for i=1:360
    for j=1:640
        new_coord = inv(affine)*[i;j;1];
        im3(i,j)=bilinear_interpolate(new_coord,im1);
    end
end

%%

figure
imshow(im1)
title("Image 1")

figure
imshow(im2)
title("Image 2")

figure
imshow(im3/255)
title("Image 3")


%%
function I = bilinear_interpolate(coords,img)
    x = coords(1);
    y = coords(2);
    I = 0;
    if x>1 && x<360 && y>1 && y<=640
        x1 = fix(x);
        y1 = fix(y);
        x2 = x1+1;
        y2 = y1+1;
        
        B = (x-x1)*(y2-y);
        A = (x2-x)*(y2-y);
        C = (x2-x)*(y-y1);
        D = (x-x1)*(y-y1);

        q11 = img(x1,y1);
        q12 = img(x1,y2);
        q21 = img(x2,y1);
        q22 = img(x2,y2);
        
        I = q11*A+q21*B+q12*C+q22*D;
    end
end
function I = nearest_interpolate(coords,img)
    x = coords(1);
    y = coords(2);
    I = 0;
    if x>1 && x<360 && y>1 && y<=640
        x1 = fix(x);
        y1 = fix(y);
        x2 = x1+1;
        y2 = y1+1;
        
        B = (x-x1)*(y2-y);
        A = (x2-x)*(y2-y);
        C = (x2-x)*(y-y1);
        D = (x-x1)*(y-y1);
        areas = [A;B;C;D];

        q11 = img(x1,y1);
        q12 = img(x1,y2);
        q21 = img(x2,y1);
        q22 = img(x2,y2);
        Is = [q11 q12 q21 q22];
        
        I = Is(find(areas==min(areas)));
    end
end
