function [R] = rotationMatrix(theta)
%ROTATIONMATRIX compute In two dimensions, to carry out a rotation using a
% matrix, the point (x,y) to be rotated counterclockwise is written as a
% column vector, then multiplied by a rotation matrix calculated from the 
% angle theta.
% INPUT:
%  theta = input angle [rad]
% OUTPUT:
%  R = rotation matrix of vector

R = [cos(theta) -sin(theta);
    sin(theta) cos(theta)];
end