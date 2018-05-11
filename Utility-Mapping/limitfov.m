function [front] = limitfov(robot, ris, it)
%LIMITFOV
% @param[in] robot,  class robot
% @param[in] ris, resolution of grid map
% @param[in] it, position iteration
% @param[out] front, limit of field of view

y = ris * robot.lasermaxdistance * sin(robot.laserTheta +robot.pf_xEst(it,3)) + robot.pf_xEst(it,2);
x = ris * robot.lasermaxdistance * cos(robot.laserTheta +robot.pf_xEst(it,3)) + robot.pf_xEst(it,1);
front = [x;y];

end