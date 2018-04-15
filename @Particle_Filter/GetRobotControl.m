function u = GetRobotControl(this, Robot, it)
u = [Robot.u(1,it)*(0.05);
    Robot.u(1,it)*(0.05);
    Robot.u(2,it)*(0.05)];
end