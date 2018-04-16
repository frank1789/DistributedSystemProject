function xnow = GetOdometry(this, Robot, it)
%GETODOMETRY  internal to robot low-level controller
%
%@param[in] Robot - class Robot
%@param[in] it - index of time simulation

if(isempty(this.LastOdom))
    this.LastOdom = this.xTrue;
end
u = this.GetRobotControl(Robot, it);
xnow = this.tcomp(this.LastOdom, u);
uNoise = sqrt(this.UTrue) * randn(3,1);
xnow = this.tcomp(xnow, uNoise);
this.LastOdom = xnow;
end