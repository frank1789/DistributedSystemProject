function [target] = Reset_Target(robot, ris, Cost_map, ii)
%RESET_TARGET Summary of this function goes here
%   Detailed explanation goes here

[front] = limitfov(robot, ris, ii);

for ll = 1:1:250
    if(isnan(robot.laserScan_2_xy{1,ii}(1,251-ll)) && front(1,251-ll)>0 && front(2,251-ll)>0)
        robot.setpointtarget([front(1,251-ll) front(2,251-ll) 0]);
        target = [front(1,251-ll) front(2,251-ll) 0];
        break
    else if(isnan(robot.laserScan_2_xy{1,ii}(1,251+ll))&& front(1,251+ll)>0 && front(2,251+ll)>0)
            robot.setpointtarget([front(1,251+ll) front(2,251+ll) 0]);
            target = [front(1,251+ll) front(2,251+ll) 0];
            break
        end
    end
end % end for-cycle

if mod(ii,160)==0
    [raw,column] = minmat(Cost_map);
    new_target =[ceil(column*0.15),ceil(17-raw*0.15),0];
    robot.setpointtarget([new_target(1) new_target(2) 0]);
    target = new_target;
end
end % function

