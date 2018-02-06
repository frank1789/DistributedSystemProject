function this = getmeasure(this, it)
%GETMEASURE the method calculates the distance of the points in the plane
% according to the formula d = sqrt(x^2 + y^2), and returns a vector
% containing the distances of the points.
% @details The method calculates the distance of the points in the plane according
% to the formula previous described, and returns a vector containing the
% distances of the points.
% It allocates two static variables that save the size of the incoming
% scans vector.
% Then check that the scans vector is not empty and calculate the distance
% for each element. If the vector is empty, a NaN vector returns.
% The variable distance is saved in the class property.
% INPUT:
% @param [in] it = iterator

persistent n m; % get the size of input vector, rmeber dimension when vector is void
laserScan_xy = this.getlaserscan(it); % assign in local variable
[n, m]= size(laserScan_xy);
if ~isempty(laserScan_xy) % check vector is not void, then compute distance
    distance = sqrt(laserScan_xy(1, :).^2 + laserScan_xy(2, :).^2);
else
    distance = nan(1, m); % return vector of NaN
end
this.distance{it} = distance;  % store in class property
end % method
