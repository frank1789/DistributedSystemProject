function [laserScan_xy] = getRawlaserScan(this, it)
%GETRAWLASERSCAN methot return the distance from laser scanner sensor in
%local robot's frame
% @param [in]   it = iterator
% @param [out]  laserScan_xy  = [x, y] points' postion
laserScan_xy = this.laserScan_2_xy{it};
end % method