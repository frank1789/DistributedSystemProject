function [xnow] = GetOdometry(k,Robot,it)

global LastOdom; %internal to robot low-level controller
global UTrue;

if(isempty(LastOdom))
global xTrue;
LastOdom = xTrue;
end;

u = GetRobotControl(k,Robot,it);
xnow =tcomp(LastOdom,u);
uNoise = sqrt(UTrue)*randn(3,1);
xnow = tcomp(xnow,uNoise);
LastOdom = xnow;
end