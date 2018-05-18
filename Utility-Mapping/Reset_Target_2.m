function [target] = Reset_Target_2(robot, ii, occparameters)
%RESET_TARGET Summary of this function goes here
%   Detailed explanation goes here

ris      = occparameters.ris;
[front] = limitfov(robot, ris, ii);
idx =  find(isnan(robot.laserScan_2_xy{1,ii}(1,:)),1);
if (isempty(idx))
    target = [front(1,251) front(2,251) 0];

elseif (idx < 251)
    for ll = idx:1:501
        % front > 0 to avoid setting target outside positive region
        if(isnan(robot.laserScan_2_xy{1,ii}(1,ll)) && front(1,ll) > 0 && front(2,ll) > 0)
            % map is suppose to be only positive
            target = [front(1,ll) front(2,ll) 0];   % 0.0063 = 0.36*(pi)/180                                                                          %0.36 lidar angular resolution
            break
        end
    end % end for-cycle

elseif (idx > 251 || idx == 251)
    for ll = idx:-1:1
        % front > 0 to avoid setting target outside positive region
        if(isnan(robot.laserScan_2_xy{1,ii}(1,ll)) && front(1,ll) > 0 && front(2,ll) > 0)
            % map is suppose to be only positive
            target = [front(1,ll) front(2,ll) 0];   % 0.0063 = 0.36*(pi)/180                                                                          %0.36 lidar angular resolution
            break
        end
    end

elseif (ll == 501 || ll == 1)
    target = [0 0 pi/30];
end

clear idx occparameters ris
end % function
