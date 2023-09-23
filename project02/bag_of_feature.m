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
   pre = training_path + strtrim(training_dir(i,:)) + "/";
   dir1 = ls(pre);
   [training_cnt(1,i - 2), len] = size(dir1);
   str = strcat(pre, dir1(3:training_cnt(1, i - 2),:));
   if (i == 3)
       imgset1 = matlab.io.datastore.ImageDatastore(str);
       bof1 = bagOfFeatures(imgset1);
       obj1 = bof1.saveobj;
       v1 = obj1.Vocabulary;
   elseif(i == 4)
       imgset2 = matlab.io.datastore.ImageDatastore(str);
       bof2 = bagOfFeatures(imgset2);
       obj2 = bof2.saveobj;
       v2 = obj2.Vocabulary;
   elseif(i == 5)
       imgset3 = matlab.io.datastore.ImageDatastore(str);
       bof3 = bagOfFeatures(imgset3);
       obj3 = bof3.saveobj;
       v3 = obj3.Vocabulary;
   elseif(i == 6)
       imgset4 = matlab.io.datastore.ImageDatastore(str);
       bof4 = bagOfFeatures(imgset4);
       obj4 = bof4.saveobj;
       v4 = obj4.Vocabulary;
   elseif(i == 7)
       imgset5 = matlab.io.datastore.ImageDatastore(str);
       bof5 = bagOfFeatures(imgset5);
       obj5 = bof5.saveobj;
       v5 = obj5.Vocabulary;
   elseif(i == 8)
       imgset6 = matlab.io.datastore.ImageDatastore(str);
       bof6 = bagOfFeatures(imgset6);
       obj6 = bof6.saveobj;
       v6 = obj6.Vocabulary;
   elseif(i == 9)
       imgset7 = matlab.io.datastore.ImageDatastore(str);
       bof7 = bagOfFeatures(imgset7);
       obj7 = bof7.saveobj;
       v7 = obj7.Vocabulary;
   elseif(i == 10)
       imgset8 = matlab.io.datastore.ImageDatastore(str);
       bof8 = bagOfFeatures(imgset8);
       obj8 = bof8.saveobj;
       v8 = obj8.Vocabulary;
   elseif(i == 11)
       imgset9 = matlab.io.datastore.ImageDatastore(str);
       bof9 = bagOfFeatures(imgset9);
       obj9 = bof9.saveobj;
       v9 = obj9.Vocabulary;
   elseif(i == 12)
       imgset10 = matlab.io.datastore.ImageDatastore(str);
       bof10 = bagOfFeatures(imgset10);
       obj10 = bof10.saveobj;
       v10 = obj10.Vocabulary;
   elseif(i == 13)
       imgset11 = matlab.io.datastore.ImageDatastore(str);
       bof11 = bagOfFeatures(imgset11);
       obj11 = bof11.saveobj;
       v11 = obj11.Vocabulary;
   elseif(i == 14)
       imgset12 = matlab.io.datastore.ImageDatastore(str);
       bof12 = bagOfFeatures(imgset12);
       obj12 = bof12.saveobj;
       v12 = obj12.Vocabulary;
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
        vimgset = matlab.io.datastore.ImageDatastore(src_path);
        vbof = bagOfFeatures(vimgset);
        vobj = vbof.saveobj;
        vv = vobj.Vocabulary;
        
%         idx = (j - 3) * 3 + 1;
        ssd = zeros(1,12);
        
        %   validation image  - training image
        for k = 1:12
                if(k == 1)
                   ret = vv - v1;
                elseif(k == 2)
                   ret = vv - v2;
                elseif(k == 3)
                   ret = vv - v3;
                elseif(k == 4)
                   ret = vv - v4;
                elseif(k == 5)
                   ret = vv - v5;
                elseif(k == 6)
                   ret = vv - v6;
                elseif(k == 7)
                   ret = vv - v7;
                elseif(k == 8)
                   ret = vv - v8;
                elseif(k == 9)
                   ret = vv - v9;
                elseif(k == 10)
                   ret = vv - v10;
                elseif(k == 11)
                   ret = vv - v11;
                elseif(k == 12)
                   ret = vv - v12;
                end
                ret = ret .^ 2;
                ssd(1,k) = sum(sum(ret));
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

csv_file = fopen("output/bag_of_feature.csv", 'w');
fprintf(csv_file, "file,species\n");

for j = 3:test_img_cnt
    src_path = test_path + "/" + timgs(j,:);
    timgset = matlab.io.datastore.ImageDatastore(src_path);
    tbof = bagOfFeatures(timgset);
    tobj = tbof.saveobj;
    tv = tobj.Vocabulary;
        
%         idx = (j - 3) * 3 + 1;
    tssd = zeros(1,12);
        
    %   validation image  - training image
%   validation image  - training image
    for k = 1:12
            for p = 1:file_number(1,k)
                if(k == 1)
                   ret = tv - v1;
                elseif(k == 2)
                   ret = tv - v2;
                elseif(k == 3)
                   ret = tv - v3;
                elseif(k == 4)
                   ret = tv - v4;
                elseif(k == 5)
                   ret = tv - v5;
                elseif(k == 6)
                   ret = tv - v6;
                elseif(k == 7)
                   ret = tv - v7;
                elseif(k == 8)
                   ret = tv - v8;
                elseif(k == 9)
                   ret = tv - v9;
                elseif(k == 10)
                   ret = tv - v10;
                elseif(k == 11)
                   ret = tv - v11;
                elseif(k == 12)
                   ret = tv - v12;
                end
                ret = ret .^ 2;
                tssd(1,k) = sum(sum(ret));
            end
    end
    [tm, tindex] = min(tssd);
    fprintf(csv_file, "%s,%s\n", strtrim(timgs(j,:)), strtrim(dirs(tindex + 2,:)));
end

fclose(csv_file);
%   =========================== end of test ===========================