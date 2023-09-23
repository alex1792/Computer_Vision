clear;
clc;

obj = VideoReader('no_teeth.mp4');
vid = read(obj);

frames = obj.NumberOfFrames;

cd source_images;
for i = 1:15
   number = num2str(i);
   file_name = strcat(number, '.jpg');
   
   frame = vid(:,:,:,i);
   imwrite(frame, file_name);
end
cd ..
obj = VideoReader('20_611410016_·¨µÎ´¸_v2.mp4');
vid = read(obj);

frames = obj.NumberOfFrames;
cd source_images
for i = frames-14:frames
   number = num2str(i - frames + 15);
   file_name = strcat('prev_', number);
   file_name = strcat(file_name, '.jpg');
   
   frame = vid(:,:,:,i);
   imwrite(frame, file_name);
end
cd ..