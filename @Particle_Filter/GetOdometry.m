function [xnow] = GetOdometry(this, Robot, it)

%internal to robot low-level controller
if(isempty(this.LastOdom))
    this.LastOdom = this.xTrue;
end

u = this.GetRobotControl(Robot, it);
xnow = this.tcomp(this.LastOdom, u);
uNoise = sqrt(this.UTrue) * randn(3,1);
xnow = this.tcomp(xnow, uNoise);
this.LastOdom = xnow;
end