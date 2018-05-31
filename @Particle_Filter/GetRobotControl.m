function u = GetRobotControl(this, Robot, it)
%GETROBOTCONTROL update the velocity
%
%@param[in] Robot - class Robot
%@param[in] it - index of time simulation

u = [Robot.u(1,it)*(0.05);
    Robot.u(1,it)*(0.05);
    Robot.u(2,it)*(0.05)];
end