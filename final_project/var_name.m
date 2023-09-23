clear;
clc

cd source_images
for i = 12:12
   fname = strcat('prev_', num2str(i));
   fname = strcat(fname, '.mat');
   
   ret = load(fname);
   a = struct();
   a.points = ret.prev_points;
   
   save(fname, '-struct', 'a');
end

for i = 12:12
%    fname = strcat('prev_', );
   fname = strcat(num2str(i), '.mat');
   
   ret = load(fname);
   a = struct();
   a.points = ret.my_points;
   
   save(fname, '-struct', 'a');
end


cd ..