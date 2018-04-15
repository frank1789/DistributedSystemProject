function this = SimulateWorld(this, Robot, it)

u = this.GetRobotControl(Robot, it);
this.xTrue = Robot.q(it,:)';
this.xTrue(3) = this.AngleWrapping(this.xTrue(3));
end