clear; close all; clc;

% data path
main_path = '/Users/swetha/Documents/2018_Spring/Data Math/Project/Data';
path_GT = fullfile(main_path, 'High_resolution/');
path_LR = fullfile(main_path, 'Low_resolution/');

save_path = '/Users/swetha/Documents/2018_Spring/Data Math/Project/Data/Registered/';
save_name = 'tongue_workspace.mat';
save_img_name = 'tongue_registered.tif';

% load image
img_GT = imread(fullfile(path_GT, 'kidney.tif'));
img_LR = imread(fullfile(path_LR, 'Kidney01-unfiltered.tif'));

figure; imshow(img_GT); title('img_GT');
figure; imshow(img_LR); title('img_LR');

% img registration
cpselect(img_LR(:,:,1),img_GT(:,:,1));

t_concord = fitgeotrans(movingPoints,fixedPoints,'nonreflectivesimilarity');
Rfixed = imref2d(size(img_GT));
registered = imwarp(img_LR,t_concord,'OutputView',Rfixed);
figure; imshow(registered); title('registered');
figure; imshowpair(img_GT,registered,'blend');

imwrite(registered,fullfile(save_path, save_img_name));
save(fullfile(save_path,save_name));


