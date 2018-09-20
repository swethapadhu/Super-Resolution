clear; close all; clc;

% data path
key_word = 'tongue';
main_path = '/Users/swetha/Documents/2018_Spring/Data Math/Project/Data/Registered_patch/';

path_GT = strcat(main_path,key_word);
path_FR = strcat(main_path,key_word,'_Result');

save_path = '/Users/yaoxiao/Documents/2018_Spring/Data Math/Project/Data/Registered_patch_Final_Pair/';
save_path = strcat(save_path,key_word,'_final_pair');

if ~exist(save_path,'dir'), mkdir(save_path); end

% load images
list_GT = dir(fullfile(path_GT, '*GT*'));
list_FR = dir(fullfile(path_FR, '*FR*'));

[files_GT,~] = sort_nat({list_GT.name});
[files_FR,~] = sort_nat({list_FR.name});

for i = 1 : length(list_GT)
    
    patch_GT = imread(fullfile(path_GT,char(files_GT(i))));
    patch_FR = imread(fullfile(path_FR,char(files_FR(i))));
    
%     figure, imshowpair(patch_GT,patch_FR,'diff');
%     figure, imshowpair(patch_GT,patch_FR,'blend');
    
    save_img_name_GT = strrep(char(files_GT(i)),'_GT_','_pair_GT_');
    save_img_name_FR = strrep(char(files_FR(i)),'_FR_','_pair_FR_');
    
    pth_gt = patch_GT(30:end-30,30:end-30,:);
    pth_fr = patch_FR(30:end-30,30:end-30,:);
    
%     figure, imshowpair(pth_gt,pth_fr,'diff');
%     figure, imshowpair(pth_gt,pth_fr,'blend');
    
    imwrite(pth_gt,fullfile(save_path, save_img_name_GT));
    imwrite(pth_fr,fullfile(save_path, save_img_name_FR));
    
end

% pth_gt = patch_GT(30:end-30,30:end-30,:);
% pth_fr = patch_FR(30:end-30,30:end-30,:);
% 
% figure, imshowpair(pth_gt,pth_fr,'diff');
% figure, imshowpair(pth_gt,pth_fr,'blend');
% 
% imwrite(pth_gt,fullfile(save_path, save_img_name_GT));
% imwrite(pth_fr,fullfile(save_path, save_img_name_FR));

