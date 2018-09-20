clear; close all; clc;

% data path
main_path = '/Users/swetha/Documents/2018_Spring/Data Math/Project/Data/Registered';
file_name = 'tongue_workspace.mat';

save_path = '/Users/swetha/Documents/2018_Spring/Data Math/Project/Data/Registered_patch/';
save_path = fullfile(save_path,strrep(file_name,'_workspace.mat',''));
%save_mat_name = 'kidney_workspace_patch.mat';

if ~exist(save_path,'dir'), mkdir(save_path); end

% initialize
patch_size = 1500;
stride = 1400;

% get GT img and the super big Registered image
img_data = load(fullfile(main_path,file_name));
image_GT = img_data.img_GT;
image_Reg = img_data.registered;

figure; imshow(image_GT); title('img_GT');
figure; imshow(image_Reg); title('img_Reg');

% corp images into patches
[Y,X,~] = size(image_GT);

idx = 0;

% for onion/tongue
for y = 1 : stride : Y-patch_size-2000
    for x = 1 :stride : X-patch_size-2000

        idx = idx + 1;
        
        patch_Reg = image_Reg(y : y+patch_size-1, x : x+patch_size-1,:);
        patch_GT = image_GT(y : y+patch_size-1, x : x+patch_size-1,:);
        
        save_name_patch_Reg = strcat(strrep(file_name,'_workspace.mat',''),'_Reg_patch_',num2str(idx),'.tif');
        save_name_patch_GT = strcat(strrep(file_name,'_workspace.mat',''),'_GT_patch_',num2str(idx),'.tif');
        
        imwrite(patch_Reg,fullfile(save_path,save_name_patch_Reg));
        imwrite(patch_GT,fullfile(save_path, save_name_patch_GT));
        
    end
end



