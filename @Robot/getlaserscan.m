function [laserScan_xy] = getlaserscan(this, it)
%GETLASERSCAN methot return the distance from laser scanner sensor
% @param [in]   it = iterator
% @param [out]  laserScan_xy  = [x, y] points' postion
laserScan_xy = this.laserScan_xy{it};
end % method
