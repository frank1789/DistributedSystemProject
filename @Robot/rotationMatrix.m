function [R] = rotationMatrix(theta)
%ROTATIONMATRIX compute the rotation matrix for a vector
% INPUT:
%  theta = input angle [rad]
% OUTPUT:
%  R = rotation matrix of vector

R = [cos(theta) -sin(theta);
    sin(theta) cos(theta)];
end