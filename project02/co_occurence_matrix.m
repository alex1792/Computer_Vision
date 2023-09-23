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


img_resize = 32;

% load 12 classes
class1 = zeros(file_number(1,1), 8, 8);
class2 = zeros(file_number(1,2), 8, 8);
class3 = zeros(file_number(1,3), 8, 8);
class4 = zeros(file_number(1,4), 8, 8);
class5 = zeros(file_number(1,5), 8, 8);
class6 = zeros(file_number(1,6), 8, 8);
class7 = zeros(file_number(1,7), 8, 8);
class8 = zeros(file_number(1,8), 8, 8);
class9 = zeros(file_number(1,9), 8, 8);
class10 = zeros(file_number(1,10), 8, 8);
class11 = zeros(file_number(1,11), 8, 8);
class12 = zeros(file_number(1,12), 8, 8);

training_cnt = uint8(zeros(1,12));

for i = 3:14
   %    dir1 are image names under class folder
   dir1 = ls(training_path + strtrim(training_dir(i,:)) + "/");
   [training_cnt(1,i - 2), len] = size(dir1);
   
   for j = 3:file_number(1,i - 2)
       training_img_path = training_path + strtrim(training_dir(i,:)) + "/" + strtrim(dir1(i,:));
       b = imread(training_img_path);
       b = imresize(b, [img_resize,img_resize]);
       b = rgb2gray(b);
       glcm = graycomatrix(b);
       idx = j - 2;
       if(i == 3)
           class1(idx,:,:) = glcm;
       elseif(i == 4)
           class2(idx,:,:) = glcm;
       elseif(i == 5)
           class3(idx,:,:) = glcm;
       elseif(i == 6)
           class4(idx,:,:) = glcm;
       elseif(i == 7)
           class5(idx,:,:) = glcm;
       elseif(i == 8)
           class6(idx,:,:) = glcm;
       elseif(i == 9)
           class7(idx,:,:) = glcm;
       elseif(i == 10)
           class8(idx,:,:) = glcm;
       elseif(i == 11)
           class9(idx,:,:) = glcm;
       elseif(i == 12)
           class10(idx,:,:) = glcm;
       elseif(i == 13)
           class11(idx,:,:) = glcm;
       elseif(i == 14)
           class12(idx,:,:) = glcm;
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
        src_img = rgb2gray(src_img);
        src_img_glcm = graycomatrix(src_img);
        
%         idx = (j - 3) * 3 + 1;
        ssd = uint64(zeros(1,12));
        
        %   validation image  - training image
        for k = 1:12
            for p = 1:file_number(1,k)
                if(k == 1)
                   ret = src_img_glcm - reshape(class1(p, :, :), [8, 8]);
                elseif(k == 2)
                   ret = src_img_glcm - reshape(class2(p, :, :), [8, 8]);
                elseif(k == 3)
                   ret = src_img_glcm - reshape(class3(p, :, :), [8, 8]);
                elseif(k == 4)
                   ret = src_img_glcm - reshape(class4(p, :, :), [8, 8]);
                elseif(k == 5)
                   ret = src_img_glcm - reshape(class5(p, :, :), [8, 8]);
                elseif(k == 6)
                   ret = src_img_glcm - reshape(class6(p, :, :), [8, 8]);
                elseif(k == 7)
                   ret = src_img_glcm - reshape(class7(p, :, :), [8, 8]);
                elseif(k == 8)
                   ret = src_img_glcm - reshape(class8(p, :, :), [8, 8]);
                elseif(k == 9)
                   ret = src_img_glcm - reshape(class9(p, :, :), [8, 8]);
                elseif(k == 10)
                   ret = src_img_glcm - reshape(class10(p, :, :), [8, 8]);
                elseif(k == 11)
                   ret = src_img_glcm - reshape(class11(p, :, :), [8, 8]);
                elseif(k == 12)
                   ret = src_img_glcm - reshape(class12(p, :, :), [8, 8]);
                end
                ret = ret .^ 2;
                ssd(1,k) = ssd(1, k) + sum(sum(ret));
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
% test_path = "test";
% timgs = ls(test_path);
% [test_img_cnt, test_name_len] = size(timgs);
% 
% csv_file = fopen("output/co_occurence_matrix.csv", 'w');
% fprintf(csv_file, "file,species\n");
% 
% for j = 3:test_img_cnt
%     src_path = test_path + "/" + timgs(j,:);
%     src_img = imread(src_path);
%     src_img = imresize(src_img, [img_resize, img_resize]);
%     src_img = rgb2gray(src_img);
%     src_img_glcm = graycomatrix(src_img);
%         
% %         idx = (j - 3) * 3 + 1;
%     tssd = zeros(1,12);
%         
%     %   validation image  - training image
% %   validation image  - training image
%     for k = 1:12
%         for p = 1:file_number(1,k)
%             if(k == 1)
%                ret = src_img_glcm - reshape(class1(p, :, :), [8, 8]);
%             elseif(k == 2)
%                ret = src_img_glcm - reshape(class2(p, :, :), [8, 8]);
%             elseif(k == 3)
%                ret = src_img_glcm - reshape(class3(p, :, :), [8, 8]);
%             elseif(k == 4)
%                ret = src_img_glcm - reshape(class4(p, :, :), [8, 8]);
%             elseif(k == 5)
%                ret = src_img_glcm - reshape(class5(p, :, :), [8, 8]);
%             elseif(k == 6)
%                ret = src_img_glcm - reshape(class6(p, :, :), [8, 8]);
%             elseif(k == 7)
%                ret = src_img_glcm - reshape(class7(p, :, :), [8, 8]);
%             elseif(k == 8)
%                ret = src_img_glcm - reshape(class8(p, :, :), [8, 8]);
%             elseif(k == 9)
%                ret = src_img_glcm - reshape(class9(p, :, :), [8, 8]);
%             elseif(k == 10)
%                ret = src_img_glcm - reshape(class10(p, :, :), [8, 8]);
%             elseif(k == 11)
%                ret = src_img_glcm - reshape(class11(p, :, :), [8, 8]);
%             elseif(k == 12)
%                ret = src_img_glcm - reshape(class12(p, :, :), [8, 8]);
%             end
%             ret = ret .^ 2;
%             tssd(1,k) = tssd(1, k) + sum(sum(ret));
%         end
%     end
%     [tm, tindex] = min(tssd);
%     fprintf(csv_file, "%s,%s\n", strtrim(timgs(j,:)), strtrim(dirs(tindex + 2,:)));
% end
% 
% fclose(csv_file);
%   =========================== end of test ===========================