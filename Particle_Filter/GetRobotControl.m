function u = GetRobotControl(k,Robot,it)
global nSteps;
u = [Robot.u(1,it)*(0.05);
     Robot.u(1,it)*(0.05);
     Robot.u(2,it)*(0.05)];
end