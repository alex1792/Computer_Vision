clear;
clc;

cd source_images
% 手動標記特徵點 參數的大小為點的個數 並儲存成.mat file
prev_img = imread('prev_1.jpg');
first_img = imread('1.jpg');

ret = cpselect(prev_img, first_img);
% save('prev_1.mat', 'fixedPoints');

cd ..

% imshow(prev_img);
% [xA,yA] = ginput(3);
% 
% imshow(first_img);
% [xB, yB] = ginput(3);
% 
% tmp = [xA yA];
% save('prev_points.mat', 'tmp');
% tmp = [xB yB];
% save('first_points.mat', 'tmp');