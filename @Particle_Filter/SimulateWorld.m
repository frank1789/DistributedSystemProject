function this = SimulateWorld(this, Robot, it)
%SIMULATEWORLD update the simulation for particle filter
%
%@param[in] Robot - class Robot
%@param[in] it - index of time simulation

u = this.GetRobotControl(Robot, it);
this.xTrue = Robot.q(it,:)';
this.xTrue(3) = this.AngleWrapping(this.xTrue(3));
end