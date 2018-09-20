function [img_lut] = apply1Dlut_optimized(img, lut)
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
 
[Y,X,C] = size(img);

img_idx = double(img(:,:,1))*256^2 + double(img(:,:,2))*256 + double(img(:,:,3));

img_idx(img_idx(:,:)==0) =1;

img_idx_fix = img_idx;

img_color = lut(img_idx_fix(:,:),:);

img_lut = reshape(img_color,[Y,X,C]);

%figure; imshow(img_lut);


img_lut = uint8(img_lut); 

end