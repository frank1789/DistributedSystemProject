function [laserScan_xy] = getlaserscan(this, it)
%GETLASERSCAN methot return the distance from laser scanner sensor
% INPUT:
%  this = refer to this object
% OUTPUT:
%     laserScan_xy (double, double) = [x, y] points' postion
laserScan_xy = this.laserScan_xy{it};
end
