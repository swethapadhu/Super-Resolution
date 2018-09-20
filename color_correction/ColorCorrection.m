close all;
clear all;
clc;
load CLUTintspline.mat
lut = CMAP;
main_path = '/Users/swetha/Documents/Spring_2018/Data_Math_Project/Data_Math_Project/Registered_patch_Final_Pair/';

%save_path = strcat(save_path,key_word,'_color_corrected');

%if ~exist(save_path,'dir'), mkdir(save_path); end

Keyword = cell(1,4);
Keyword{1,1} = 'tongue_final_pair';
Keyword{1,2} = 'stone_final_pair';
Keyword{1,3} = 'onion_final_pair';
Keyword{1,4} = 'kidney_final_pair';

for w=1:4
save_path ='/Users/shrutisivakumar/Documents/Spring_2018/Data_Math_Project Data_Math_Project/OnlyAverage/SplineInterpol/';

    save_path = strcat(save_path,Keyword{1,w},'_color_corrected');
    path_FR = strcat(main_path,Keyword{1,w}); 
    
    list_FR = dir(fullfile(path_FR, '*FR*')); 
    [files_FR,~] = sort_nat({list_FR.name});
    
    for i = 1 : length(list_FR)
        img = imread(fullfile(path_FR,char(files_FR(i))));
        corr_image = apply1Dlut(img, lut);
       
       

if ~exist(save_path,'dir'), mkdir(save_path); end

     %save_img_name_FR = strrep(char(files_FR(i)),'_FR_','_pair_FR_');
    imwrite(corr_image,fullfile(save_path, char(files_FR(i)))); 
   % imwrite(corr_image,fullfile(save_path, save_img_name_FR));
        
        
    end
    
    
    
    
end
