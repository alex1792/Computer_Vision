clear;
clc

scale = 2;
orientation = 90;

img1 = imread("training/Black-grass/2aa60045d.png");
r = imgaborfilt(img1(:,:,1), scale, orientation);
g = imgaborfilt(img1(:,:,2), scale, orientation);
b = imgaborfilt(img1(:,:,3), scale, orientation);
gray = rgb2gray(img1);
gray = imgaborfilt(gray, scale, orientation);

figure;
subplot(1,4,1), imshow(r);
subplot(1,4,2), imshow(g);
subplot(1,4,3), imshow(b);
subplot(1,4,4), imshow(gray);
