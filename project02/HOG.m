clear;
clc

%   =========================== read training data ===========================
training_path = "training/";
training_dir = ls(training_path);
file_number = uint16(zeros(1,12));
for i = 3:14
    class_path = training_path + strtrim(training_dir(i,:)) + "/*.png";
    file_number(1,i - 2) = numel(dir(class_path));
end

feature_len = 34596;
img_resize = 256;

% load 12 classes
class1 = zeros(file_number(1,1), feature_len);
class2 = zeros(file_number(1,2), feature_len);
class3 = zeros(file_number(1,3), feature_len);
class4 = zeros(file_number(1,4), feature_len);
class5 = zeros(file_number(1,5), feature_len);
class6 = zeros(file_number(1,6), feature_len);
class7 = zeros(file_number(1,7), feature_len);
class8 = zeros(file_number(1,8), feature_len);
class9 = zeros(file_number(1,9), feature_len);
class10 = zeros(file_number(1,10), feature_len);
class11 = zeros(file_number(1,11), feature_len);
class12 = zeros(file_number(1,12), feature_len);

training_cnt = uint8(zeros(1,12));

for i = 3:14
   %    dir1 are image names under class folder
   dir1 = ls(training_path + strtrim(training_dir(i,:)) + "/");
   [training_cnt(1,i - 2), len] = size(dir1);
   
   for j = 3:file_number(1,i - 2)
       training_img_path = training_path + strtrim(training_dir(i,:)) + "/" + strtrim(dir1(i,:));
       b = imread(training_img_path);
       b = imresize(b, [img_resize,img_resize]);
       hog_feature = extractHOGFeatures(b);
       idx = j - 2;
       if(i == 3)
           class1(idx,:) = hog_feature;
       elseif(i == 4)
           class2(idx,:) = hog_feature;
       elseif(i == 5)
           class3(idx,:) = hog_feature;
       elseif(i == 6)
           class4(idx,:) = hog_feature;
       elseif(i == 7)
           class5(idx,:) = hog_feature;
       elseif(i == 8)
           class6(idx,:) = hog_feature;
       elseif(i == 9)
           class7(idx,:) = hog_feature;
       elseif(i == 10)
           class8(idx,:) = hog_feature;
       elseif(i == 11)
           class9(idx,:) = hog_feature;
       elseif(i == 12)
           class10(idx,:) = hog_feature;
       elseif(i == 13)
           class11(idx,:) = hog_feature;
       elseif(i == 14)
           class12(idx,:) = hog_feature;
       end
   end
end
%   =========================== end of reading training data ===========================

%   =========================== validation ===========================
dirs = ls("validation");
[cnt0, len] = size(dirs);

total = 0;
correct = 0;

%   for each validation class
for i = 3:cnt0
    class_path = "validation/" + strtrim(dirs(i,:));
    imgs = ls(class_path);
    [img_cnt, name_len] = size(imgs);
    
    
    %   for each image in class
    for j = 3:img_cnt
        src_path = class_path + "/" + imgs(j,:);
        src_img = imread(src_path);
        src_img = imresize(src_img, [img_resize, img_resize]);
        src_img_hog_feature = extractHOGFeatures(src_img);
        
%         idx = (j - 3) * 3 + 1;
        ssd = zeros(1,12);
        
        %   validation image  - training image
        for k = 1:12
            for p = 1:file_number(1,k)
                if(k == 1)
                   ret = src_img_hog_feature - class1(p,:);
                elseif(k == 2)
                   ret = src_img_hog_feature - class2(p,:);
                elseif(k == 3)
                   ret = src_img_hog_feature - class3(p,:);
                elseif(k == 4)
                   ret = src_img_hog_feature - class4(p,:);
                elseif(k == 5)
                   ret = src_img_hog_feature - class5(p,:);
                elseif(k == 6)
                   ret = src_img_hog_feature - class6(p,:);
                elseif(k == 7)
                   ret = src_img_hog_feature - class7(p,:);
                elseif(k == 8)
                   ret = src_img_hog_feature - class8(p,:);
                elseif(k == 9)
                   ret = src_img_hog_feature - class9(p,:);
                elseif(k == 10)
                   ret = src_img_hog_feature - class10(p,:);
                elseif(k == 11)
                   ret = src_img_hog_feature - class11(p,:);
                elseif(k == 12)
                   ret = src_img_hog_feature - class12(p,:);
                end
                ret = ret .^ 2;
                ssd(1,k) = ssd(1, k) + sum(ret);
            end
        end
        [m, index] = min(ssd);
%         dirs(2 + index,:)
%         m
        if(index == i - 2)
            correct = correct + 1;
        end
        total = total + 1;
    end
end
accuracy = correct / total
%   =========================== end of validation ===========================

%   =========================== test ===========================
test_path = "test";
timgs = ls(test_path);
[test_img_cnt, test_name_len] = size(timgs);

csv_file = fopen("output/hog_feature.csv", 'w');
fprintf(csv_file, "file,species\n");

for j = 3:test_img_cnt
    src_path = test_path + "/" + timgs(j,:);
    src_img = imread(src_path);
    src_img = imresize(src_img, [img_resize, img_resize]);
    src_img_hog_feature = extractHOGFeatures(src_img);
        
%         idx = (j - 3) * 3 + 1;
    tssd = zeros(1,12);
        
    %   validation image  - training image
%   validation image  - training image
    for k = 1:12
            for p = 1:file_number(1,k)
                if(k == 1)
                   ret = src_img_hog_feature - class1(p,:);
                elseif(k == 2)
                   ret = src_img_hog_feature - class2(p,:);
                elseif(k == 3)
                   ret = src_img_hog_feature - class3(p,:);
                elseif(k == 4)
                   ret = src_img_hog_feature - class4(p,:);
                elseif(k == 5)
                   ret = src_img_hog_feature - class5(p,:);
                elseif(k == 6)
                   ret = src_img_hog_feature - class6(p,:);
                elseif(k == 7)
                   ret = src_img_hog_feature - class7(p,:);
                elseif(k == 8)
                   ret = src_img_hog_feature - class8(p,:);
                elseif(k == 9)
                   ret = src_img_hog_feature - class9(p,:);
                elseif(k == 10)
                   ret = src_img_hog_feature - class10(p,:);
                elseif(k == 11)
                   ret = src_img_hog_feature - class11(p,:);
                elseif(k == 12)
                   ret = src_img_hog_feature - class12(p,:);
                end
                ret = ret .^ 2;
                tssd(1,k) = tssd(1, k) + sum(ret);
            end
    end
    [tm, tindex] = min(tssd);
    fprintf(csv_file, "%s,%s\n", strtrim(timgs(j,:)), strtrim(dirs(tindex + 2,:)));
end

fclose(csv_file);
%   =========================== end of test ===========================