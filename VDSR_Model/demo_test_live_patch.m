close all; clear; clc;

main_path = '/data/Yao/Data_Math_Project/Demo_Test_data_Apr30/PairedData_patch';
save_main_path = './PairedData_patch_vdsr_YCbCr_33_new/';

model = './VDSR_mat.prototxt';
weights = './ss_vdsr_iter_1500000.caffemodel';


%% use gpu mode
caffe.reset_all();
caffe.set_mode_gpu();
caffe.set_device(0);

net = caffe.Net(model,weights,'test');
%% test
folders = dir(fullfile(main_path,'*_Patch'));

test_time_all = [];
%psnr_lr_YCC = [];
%psnr_sr_YCC = [];
%psnr_lr_RGB = [];
%psnr_sr_RGB = [];

for fld_i = 1:length(folders)
    
    files_LR = dir(fullfile(main_path,folders(fld_i).name,'*FR*'));
   % files_GT = dir(fullfile(main_path,folders(fld_i).name,'*GT*'));
    
    save_path = strcat(save_main_path,folders(fld_i).name,'_vdsr');
    if ~exist(save_path,'dir'), mkdir(save_path); end
    
    for i = 1:length(files_LR)
        img_LR = imread(fullfile(main_path,folders(fld_i).name,files_LR(i).name));
        %img_GT = imread(fullfile(main_path,folders(fld_i).name,files_GT(i).name));
        
	%% work on illuminance only
        if size(img_LR,3)>1
            im_lr = rgb2ycbcr(img_LR);
            im_lr = im_lr(:, :, 1);
            %im_gt = rgb2ycbcr(img_GT);
            %im_gt = im_gt(:, :, 1);
        end
        im_lr = im2double(im_lr);
        %im_gnd = im2double(im_gt);

        [Y,X] = size(im_lr);
        
        % test
        tic;
        % net = caffe.Net(model,weights,'test');
        net.blobs('data').reshape([Y X 1 1]); % reshape blob 'data'
        net.reshape();
        net.blobs('data').set_data(im_lr);
        net.forward_prefilled();
        output = net.blobs('sum').get_data();
        
        test_time = toc;
	test_time_all(fld_i,i) = test_time;
        
	img_sr = double(imresize(output,[Y,X]));
        im_h = img_sr;
	
	%% compute PSNR
        %psnr_srcnn_lr = compute_psnr(im_lr,im_gnd);
        %psnr_srcnn = compute_psnr(im_h,im_gnd);
        
        %psnr_lr_YCC(fld_i,i) = psnr_srcnn_lr;
        %psnr_sr_YCC(fld_i,i) = psnr_srcnn;
        
        img_lr = rgb2ycbcr(img_LR);
        img_sr = uint8(im_h*255);
        img_sr(:,:,2) = img_lr(:,:,2);
        img_sr(:,:,3) = img_lr(:,:,3);
        img_sr_rgb = ycbcr2rgb(img_sr);
        
        %psnr_srcnn_lr_rgb = psnr(img_LR,img_GT);
        %psnr_srcnn_sr_rgb = psnr(img_sr_rgb,img_GT);
        
        %psnr_lr_RGB(fld_i,i) = psnr_srcnn_lr_rgb;
        %psnr_sr_RGB(fld_i,i) = psnr_srcnn_sr_rgb;
        
        %% show results
%         fprintf('testing time: %3.5f\n',test_time);
%         fprintf('PSNR for lr Y channel 0-1: %f dB\n', psnr_srcnn_lr);
%         fprintf('PSNR for sr Y channel 0-1: %f dB\n', psnr_srcnn);
%         fprintf('PSNR for LR RGB: %f dB\n', psnr_srcnn_lr_rgb);
%         fprintf('PSNR for SR RGB: %f dB\n', psnr_srcnn_sr_rgb);
        
%         figure, imshow(im_gnd); title('GT Y channel 0-1');
%         figure, imshow(im_h); title('SR Y channel 0-1');
%         figure, imshow(im_lr); title('LR Y channel 0-1');
%         
%         figure, imshow(img_GT); title('GT RGB 0-255');
%         figure, imshow(img_sr_rgb); title('SR RGB 0-255');
%         figure, imshow(img_LR); title('LR Y channel 0-255');
        
        imwrite(img_sr_rgb,fullfile(save_path,files_LR(i).name));
    end
    
end
%psnr_lr_YCC_mean = mean(mean(psnr_lr_YCC));
%psnr_sr_YCC_mean = mean(mean(psnr_sr_YCC));
%psnr_lr_RGB_mean = mean(mean(psnr_lr_RGB));
%psnr_sr_RGB_mean = mean(mean(psnr_sr_RGB));
%test_time_mean = mean(mean(test_time_all));

%psnr_YCC_mean_dif = psnr_sr_YCC_mean - psnr_lr_YCC_mean;
%psnr_RGB_mean_dif =  psnr_sr_RGB_mean - psnr_lr_RGB_mean;

%fprintf('mean PSNR for lr Y channel 0-1: %f dB\n', psnr_lr_YCC_mean);
%fprintf('mean PSNR for sr Y channel 0-1: %f dB\n', psnr_sr_YCC_mean);
%fprintf('mean PSNR for LR RGB: %f dB\n', psnr_lr_RGB_mean);
%fprintf('mean PSNR for SR RGB: %f dB\n', psnr_sr_RGB_mean);

%fprintf('mean difference PSNR for YCbCr SR - LR: %f dB\n', psnr_YCC_mean_dif);
%fprintf('mean difference PSNR for RGB SR - LR: %f dB\n', psnr_RGB_mean_dif);

fprintf('mean test time: %3.5f second\n',sum(test_time_all,2)); 

%save(fullfile(save_main_path,'test_results.mat'),'test_time_all',...
%    'psnr_lr_YCC','psnr_sr_YCC','psnr_lr_RGB','psnr_sr_RGB',...
%    'psnr_lr_YCC_mean','psnr_sr_YCC_mean','psnr_lr_RGB_mean','psnr_sr_RGB_mean',...
%    'psnr_YCC_mean_dif','psnr_RGB_mean_dif','test_time_mean');


