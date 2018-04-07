function this = setpoints(this, data)
% setpoints extract point from matrix by indicies.
% incoming matrix and extracts the indices, so store in field points.
% @param [in] data = matrix from map generator

[row, col] = find(data(:,:));
this.points = [col.';row.'];

clear row col
end % function