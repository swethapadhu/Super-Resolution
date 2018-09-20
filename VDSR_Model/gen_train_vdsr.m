clear;close all;clc;
%% settings
%folder
path_CC = '/Users/yaoxiao/Documents/2018_Spring/Data Math/Project/Data/ColorCorrected/';
path_GT = '/Users/yaoxiao/Documents/2018_Spring/Data Math/Project/Data/Registered_patch_Final_Pair/';

path_save = '/Users/yaoxiao/Documents/2018_Spring/Data Math/Project/Preprocess/';

p = .8;      % proportion of rows to select for training
size_input = 33;
stride = 14;

%% generate data

folders_CC = dir(fullfile(path_CC,'*Corrected'));
folders_GT = dir(fullfile(path_GT,'*final_pair'));

for folder_i = 1:length(folders_CC)
    
    savepath = fullfile(path_save,strrep(folders_CC(folder_i).name,'_Corrected','/'));
    savefile = fullfile(savepath,strrep(folders_CC(folder_i).name,'_Corrected','_train.h5'));
    
    if ~exist(savepath,'dir'), mkdir(savepath); end
    
    files_CC = dir(fullfile(path_CC,folders_CC(folder_i).name,'*FR*'));
    files_GT = dir(fullfile(path_GT,folders_GT(folder_i).name,'*GT*'));
    
    [files_cc,index_cc] = sort_nat({files_CC.name});
    [files_gt,index_gt] = sort_nat({files_GT.name});
    
    % split dataset into training and testing sets
    N = size(files_cc,2);  % total number of rows
    tf = false(N,1);    % create logical index vector
    tf(1:round(p*N)) = true;
    tf = tf(randperm(N));   % randomise order, 1 for training, 0 for testing
    
    save(fullfile(savepath,'split.mat'),'tf');
    
    % get data and label for training set and testing set
    files_cc_train = files_cc(tf);
    files_gt_train = files_gt(tf);
    
    %% initialization
    data = zeros(size_input, size_input, 1, 1);
    label = zeros(size_input, size_input, 1, 1);
    count = 0;
    
    for i = 1 : length(files_cc_train)
        
        img_cc = imread(fullfile(path_CC,folders_CC(folder_i).name,char(files_cc_train(i))));
        img_gt = imread(fullfile(path_GT,folders_GT(folder_i).name,char(files_gt_train(i))));
        
        %img_cc = rgb2ycbcr(img_cc);
        img_cc = rgb2gray(img_cc);
        img_cc = im2double(img_cc(:, :, 1));
        
        %img_gt = rgb2ycbcr(img_gt);
        img_gt = rgb2gray(img_gt);
        img_gt = im2double(img_gt(:, :, 1));
        
        [hei,wid] = size(img_cc);
        
        for x = 1 : stride : hei-size_input+1
            for y = 1 :stride : wid-size_input+1
                
                subim_input = img_cc(x : x+size_input-1, y : y+size_input-1);
                subim_label = img_gt(x : x+size_input-1, y : y+size_input-1);
                
                count=count+1;
                data(:, :, 1, count) = subim_input;
                label(:, :, 1, count) = subim_label;
            end
        end
    end
    
    order = randperm(count);
    data = data(:, :, 1, order);
    label = label(:, :, 1, order);
    
    %% writing to HDF5
    chunksz = 128;
    created_flag = false;
    totalct = 0;
    
    for batchno = 1:floor(count/chunksz)
        last_read=(batchno-1)*chunksz;
        batchdata = data(:,:,1,last_read+1:last_read+chunksz);
        batchlabs = label(:,:,1,last_read+1:last_read+chunksz);
        
        startloc = struct('dat',[1,1,1,totalct+1], 'lab', [1,1,1,totalct+1]);
        curr_dat_sz = store2hdf5(savefile, batchdata, batchlabs, ~created_flag, startloc, chunksz);
        created_flag = true;
        totalct = curr_dat_sz(end);
    end
    h5disp(savefile);
    
    fprintf('done %s\n',folders_CC(folder_i).name);
end
fprintf('all done\n');
