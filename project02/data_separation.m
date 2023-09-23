clear;
clc

% get number of classes
home = pwd();
path = "train/";
classes = ls(path);
[classNbr, classLenth] = size(classes);

%   data separation: devided into two parts
%   1). training data -> /training/
%   2). validation data -> /validation/
%   3). output csv file -> /output/
[status, msg] = mkdir("validation");    %   making a directory to save validation data (home/validation)
[status, msg] = mkdir("training");      %   making a directory to save training data (home/training)
[status, msg] = mkdir("output");
for i = 3:classNbr 
    vali_path = home + "/validation/" + strtrim(classes(i,:));   %   Using strtrim() to remove additional whitespace
    training_path = home + "/training/" + strtrim(classes(i,:));
    [status, msg] = mkdir(vali_path);    %   making a directory of classes home/validation/className
    [status, msg] = mkdir(training_path);   %   making a directory of classes home/training/className
    current_path = path + classes(i,:);
    imgs = ls(current_path);    %   list all files(training images) in home/train/className
    [img_cnt, name_len] = size(imgs);   %   get total images count (including '.' and '..')
    mid = round((img_cnt - 2) / 2) + 3; %   compute the middle index
    
    src_path = path + strtrim(classes(i,:));    %   source path 
    cd(src_path)    %   go into the source path (home/train/ClassName/)
    for j = 3:mid - 1
        a = imread(strtrim(imgs(j,:)));
        a = imgaussfilt(a, 2);
        a = imresize(a, [256, 256]);
%         training_path + "/" + strtrim(imgs(j,:))
        imwrite(a, training_path + "/" + strtrim(imgs(j,:)));
%         copyfile(imgs(j,:), training_path); %   copy first half images to home/training/className as training data
    end
    for j = mid:img_cnt
        a = imread(imgs(j,:));
        a = imgaussfilt(a, 2);
        a = imresize(a, [256, 256]);
        imwrite(a, vali_path + "/" + strtrim(imgs(j,:)));
%         copyfile(imgs(j,:), vali_path);  %   copy rest images to home/validation/ClassName
    end
    cd("..")    %   go back to home/train/
    cd("..")    %   go back to home/
    
end