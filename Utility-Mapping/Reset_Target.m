function [target] = Reset_Target(robot,ii, occparameters)
%RESET_TARGET Summary of this function goes here
%   Detailed explanation goes here
ris      = occparameters.ris;
Cost_map = occparameters.Cost_map;

[front] = limitfov(robot, ris, ii);

for ll = 1:1:250
    if(isnan(robot.laserScan_2_xy{1,ii}(1,251-ll)) && front(1,251-ll)>0 && front(2,251-ll)>0) %front > 0 to avoid setting target outside positive region
        robot.setpointtarget([front(1,251-ll) front(2,251-ll) 0 ]);                           %map is suppose to be only positive
        target = [front(1,251-ll) front(2,251-ll) 0];    %0.0063 = 0.36*(pi)/180 
                                                                               %0.36 lidar angular resolution
        break
    else if(isnan(robot.laserScan_2_xy{1,ii}(1,251+ll))&& front(1,251+ll)>0 && front(2,251+ll)>0)
            robot.setpointtarget([front(1,251+ll) front(2,251+ll) 0]);
            target = [front(1,251+ll) front(2,251+ll) 0];
            break
        end
    end
end % end for-cycle

if(ll==250)
target = [0 0 pi/8];
end

end % function

