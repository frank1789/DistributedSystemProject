function [ point ] = getAvailablePoints(this)
% getAvailablePoints extract point from matrix by indicies for robot
% position.
% incoming matrix and extracts the indices, so store in field points.
% @param [in] input = matrix from map generator

x = randi(length(this.available));
    point = [this.available(:,x).', 0];

end % function