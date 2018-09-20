clear; close all; clc;

main_path = './Test_img_color_corred_result_finalData/';
ori_path = '../High_resolution/';
save_main_path = './FinalData_patch/';

stride = 1500;
size_patch = 1500;

if ~exist(save_main_path,'dir'), mkdir(save_main_path); end
    
files = dir(fullfile(main_path,'*.tif'));
%files_ori = dir(fullfile(ori_path,'*.tif'));

for i = 1: length(files)
    
    save_path = strcat(save_main_path, strrep(files(i).name,'01_image_color_corrected.tif','_FinalData_Pathch/'));
    if ~exist(save_path,'dir'), mkdir(save_path); end
    
    image = imread(fullfile(main_path,files(i).name));
    %image_ori = imread(fullfile(ori_path,files_ori(i).name));
    
    %img = modcrop_center(image, modcrop);
    
    [Y,X,C] = size(image);
    idx = 0;
    
    for j = 1 : stride: Y - size_patch+1
        for k = 1 : stride: X - size_patch+1
            
            idx = idx + 1;
            %x : x+size_input-1, y : y+size_input-1
            
            img_patch = image(j : j+size_patch-1, k : k+size_patch-1,:);
            %img_patch_ori = image_ori(j : j+size_patch-1, k : k+size_patch-1,:);
            
            imwrite(img_patch,fullfile(save_path,[strrep(files(i).name,'01_image_color_corrected.tif','_finalData_pathch_'),num2str(idx),'.tif']));
            %imwrite(img_patch,fullfile(save_path,[strrep(files(i).name,'01_image_color_corrected.tif','_CC_pathch_'),num2str(idx),'.tif']));
            %imwrite(img_patch,fullfile(save_path,[strrep(files(i).name,'01_image_color_corrected.tif','_Ori_pathch_'),num2str(idx),'.tif']));
        end
    end
end
