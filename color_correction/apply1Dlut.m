function [img_lut] = apply1Dlut(img, lut)
%Inputs:
%    img - the image on which the lut shall be applied, format double,
%            uint8 or uint16
%    lut - the color lookup table (either 1D or 3D)
%    kind - a string '1D' or '3D' specifying whether a 1D LUT or 3D LUT is
%           used
%    order - order of LUT entries. 'RGB' or'BGR' order.Use 'standard'
%    colorScheme - determines RGB or BGR channel order
% Outputs:
%    img_lut - image after colors are changed according to LUT,
%              format double, uint8 or uint16 depending on LUT values
%
% Example: 
%    img = imread('path_to_image');
%    lut = dlmread('path_to_lut.cube', ' ', 4, 0);
%    Our case
%    load Color_LUT.mat
%    [img_lut] = imlut(img, lut, '3D', 'standard', 'RGB');
%    imshow(img_lut)
 
[m,n,o] = size(img);

img_idx = double(img(:,:,1))*256^2 + double(img(:,:,2))*256 + double(img(:,:,3));
img_idx(img_idx(:,:)==0) =1;

img_color = lut(img_idx(:,:),:);
img_color_reshape = reshape(img_color,[Y,X,C]);

figure; imshow(img_color_reshape);

% img_cor(img_idx(:,:)==0) = [0,0,0];
% img_col = lut(img_idx(:,:),:);



for i=1:m
    for j=1:n
        for k=1:o
            index = (double(img(i,j,1))*256*256)+ ((double(img(i,j,2)))*256) +(double(img(i,j,3)));
            if index == 0
            img_lut(i,j,1) = 0;
            img_lut(i,j,2) = 0;
            img_lut(i,j,3) = 0;
            else
            
            img_lut(i,j,1) = lut(index,1);
            img_lut(i,j,2) = lut(index,2);
            img_lut(i,j,3) = lut(index,3);
            end
        end
    end
end
img_lut = uint8(img_lut); 

end