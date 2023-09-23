clear;
clc
%   ��key frame
% vidObj = VideoReader('20_611410016_���δ�.mp4');
% vidObj = VideoReader('my_vid.mp4');
% vidObj.CurrentTime = 112.680;

% vidFrame = readFrame(vidObj);
% imshow(vidFrame)

%   �e�@�ӤH���̫�@�iframe
% imwrite(vidFrame, 'prev_last_frame.jpg');
% imwrite(vidFrame, 'my_first_frame.jpg');


% prev_img = imread('prev_last_frame.jpg');
% first_img = imread('my_first_frame.jpg');

% ��ʼаO�S�x�I �Ѽƪ��j�p���I���Ӽ� ���x�s��.mat file
% imshow(prev_img);
% [xA,yA] = ginput(3);

% imshow(first_img);
% [xB, yB] = ginput(3);

% tmp = [xA yA];
% save('prev_points.mat', 'tmp');
% tmp = [xB yB];
% save('first_points.mat', 'tmp');

%   Ū���аO���I
cd source_images
prev_points = zeros(52, 30, 1);
my_points = zeros(52, 30, 1);
for i = 1:15
   nbr = num2str(i);
   fname = strcat('prev_',nbr);
   fname = strcat(fname, '.mat');
   ret = load(fname);
   prev_points(:,i * 2 - 1:i*2) = ret.points;
   
   fname2 = strcat(num2str(i), '.mat');
   ret = load(fname2);
   my_points(:,i*2-1:i*2) = ret.points;
end

% ret = load('prev_1.mat');
% prev_points = ret.prev_points;

% ret = load('1_v2.mat');
% my_points = ret.my_points;

% prev_img = imread('prev_1.jpg');
% first_img = imread('1.jpg');

cd ..


cd('morphing_images');
video = VideoWriter('output');
open(video);

%  ��for�j�鲣��30�i�Ӥ� �ꦨ1���v��
for i = 1:15
    str = string(i) + '.jpg';
    
    cd ..
    cd source_images
    fname = strcat('prev_', num2str(i));
    fname = strcat(fname, '.jpg');
    prev_img = imread(fname);
    
    fname2 = strcat(num2str(i), '.jpg');
    first_img = imread(fname2);
    cd ..
    cd morphing_images
    
%     str
%   �ѦҺ����W��code ��call��function
%   xA�ByA��prev_img���S�x�I
%   xB�ByB��first_img���S�x�I
    ret = mesh_based_warping(first_img, prev_img, 52, i / 15,my_points(:,2*i-1), my_points(:,2*i), prev_points(:,2*i-1), prev_points(:,2*i));
    imwrite(ret, str);
    writeVideo(video, imread(str));
end
cd('..');

close(video);
