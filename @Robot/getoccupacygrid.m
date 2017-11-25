function [occupacygrid] = getoccupacygrid(this, it)
%GETOCCUPACYGRID return the occupacy grid by calling before the
% setoccupacygrid method generates a plot by scanning the laser sensor
% as scattered points in the plane, so this plot is converted into a frame
% and analyzed as an image by returning the occupacy grid as a
% matrix [m, n] (double), where m == n (square matrix)
% INPUT:
%  this (object) = refer to this object
%  it (int) = iterator from the loop to locate the step
% OUTPUT:
%  occupacygrid (double) = matrix [m, n]

tempoccupacygrid = this.setoccupacygrid(it);

% get dimension of occupacy grid
[m, n] = size(tempoccupacygrid);

if m == n % verify occupacy matrix is square
    occupacygrid = tempoccupacygrid;
else
    % make complementary matrix (must be square)
    complement = zeros(n - m, n) + 0;
    % overwrite input parameter
    occupacygrid = cat(1, tempoccupacygrid, complement);
end
clear tempoccupacygrid
end % function
