function [ this ] = setAvailablePoints(this, input)
% setAvailablePoints extract point from matrix by indicies for robot
% position.
% incoming matrix and extracts the indices, so store in field points.
% @param [in] input = matrix from map generator

[row, col] = find(input(:,:) == 0);
this.available = [col.';row.'];

clear row col
end % function