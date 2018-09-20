clear; close all; clc;

% data path
key_word = 'onion';
main_path = '/Users/swetha/Documents/2018_Spring/Data Math/Project/Data/Registered_patch/';
main_path = strcat(main_path,key_word);

save_path = '/Users/swetha/Documents/2018_Spring/Data Math/Project/Data/Registered_patch/';
save_path = strcat(save_path,key_word,'_Result');

if ~exist(save_path,'dir'), mkdir(save_path); end

files_GT = dir(fullfile(main_path, '*GT*'));
files_Reg1 = dir(fullfile(main_path, '*Reg*'));

% load image
for i = 1:length(files_GT)
    patch_GT = imread(fullfile(main_path,files_GT(i).name));
    patch_Reg1 = imread(fullfile(main_path,files_Reg1(i).name));
    
    % figure; imshow(patch_GT); title('patch_GT');
    % figure; imshow(patch_Reg1); title('patch_Reg1');
    
    % img registration
    
    ptsOriginal  = detectSURFFeatures(patch_GT(:,:,1));
    ptsDistorted = detectSURFFeatures(patch_Reg1(:,:,1));
    
    [featuresOriginal, validPtsOriginal]  = extractFeatures(patch_GT(:,:,1), ptsOriginal);
    [featuresDistorted, validPtsDistorted]  = extractFeatures(patch_Reg1(:,:,1), ptsDistorted);
    
    indexPairs = matchFeatures(featuresOriginal, featuresDistorted);
    
    matchedOriginal  = validPtsOriginal(indexPairs(:,1));
    matchedDistorted = validPtsDistorted(indexPairs(:,2));
    
    % Show point matches. Notice the presence of outliers.
    %     figure;
    %     showMatchedFeatures(patch_GT,patch_Reg1,matchedOriginal,matchedDistorted);
    %     title('Putatively matched points (including outliers)');
    
    % affine for kidney
    
    [tform, inlierDistorted, inlierOriginal] = estimateGeometricTransform(...
        matchedDistorted, matchedOriginal, 'affine');
    
    % Display matching point pairs used in the computation of the transformation matrix
    %     figure;
    %     showMatchedFeatures(patch_GT,patch_Reg1, inlierOriginal, inlierDistorted);
    %     title('Matching points (inliers only)');
    %     legend('ptsOriginal','ptsDistorted');
    
    % Solve for Scale and Angle
    Tinv  = tform.invert.T;
    
    ss = Tinv(2,1);
    sc = Tinv(1,1);
    scale_recovered = sqrt(ss*ss + sc*sc);
    theta_recovered = atan2(ss,sc)*180/pi;
    
    % Recover the Original Image
    outputView = imref2d(size(patch_GT));
    recovered  = imwarp(patch_Reg1,tform,'OutputView',outputView);
    
    figure, imshowpair(patch_GT,recovered,'diff');
    figure, imshowpair(patch_GT,recovered,'blend');
    
    img_mse = immse(recovered,patch_GT);
    
    save_img_name = strrep(files_GT(i).name,'_GT_','_FR_');
    
    imwrite(recovered,fullfile(save_path, save_img_name));
    
end

