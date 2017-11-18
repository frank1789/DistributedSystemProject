function [ Occ_Grid ] = OccupacyGrid_from_Image(image)
%OCCUPACYGRID Summary of this function goes here
%   Detailed explanation goes here

image_2 = imread(image);
image_2 = rgb2gray(image_2);
imshow(image_2);

imageNorm = double(image_2)/255;
Occ_Grid = 1 - imageNorm;

end % function

