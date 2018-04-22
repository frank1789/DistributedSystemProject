function [target] = Reset_Target(robot, ris, Cost_map, ii)
%RESET_TARGET Summary of this function goes here
%   Detailed explanation goes here

[front] = limitfov(robot, ris, ii);

% for ll = 1:1:250
%     if(isnan(robot.laserScan_2_xy{1,ii}(1,251-ll)) && front(1,251-ll)>0 && front(2,251-ll)>0)
%         robot.setpointtarget([front(1,251-ll) front(2,251-ll) robot.q(ii,3)-0.0063*ll]);
%         target = [front(1,251-ll) front(2,251-ll) robot.q(ii,3)-0.0063*ll];    %0.0063 = 0.36*(pi)/180 
%                                                                                %0.36 lidar angular resolution
%         break
%     else if(isnan(robot.laserScan_2_xy{1,ii}(1,251+ll))&& front(1,251+ll)>0 && front(2,251+ll)>0)
%             robot.setpointtarget([front(1,251+ll) front(2,251+ll) robot.q(ii,3)+0.0063*ll]);
%             target = [front(1,251+ll) front(2,251+ll) robot.q(ii,3)+0.0063*ll];
%             break
%         end
%     end
% end % end for-cycle
% 
% if(ll==250)
% target = [front(1,251) front(2,251) robot.q(ii,3)];;
% end
% 
% if mod(ii,160)==0
%     [raw,column] = minmat(Cost_map);
%     robot.setpointtarget([ceil(column*0.15),ceil(17-raw*0.15),robot.q(ii,3)]);
%     target = [ceil(column*0.15),ceil(17-raw*0.15),robot.q(ii,3)];
% end
% if(ll==250)
% target = [front(1,251) front(2,251) 0];
% end
% 
% end
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

