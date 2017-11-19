function this = setoccupacygrid(this, image)
%SETOCCUPACYGRID method to generate matrix of occupacy propability
% INPUT:
%   this: refer object this class
%   image (string): image's name file
% RETURN:
%   this: refer object this class
%   this.occupacygrid (double): matrix contenent occupacy propability

this.namemap = image;           % store image
image_2 = imread(image);        % read the image
image_2 = rgb2gray(image_2);    % convert from color gray scale

% show map
namemap = sprintf('Map: %s', this.namemap);
map = figure('Name', namemap);
imshow(image_2);
pause(5);
close(map);

% set the occupacy grid
imageNorm = double(image_2)/255;
Occ_Grid = 1 - imageNorm;
this.occupacygrid = Occ_Grid; % return the occupacy grid
end % function