function SimulateWorld(k,Robot,it)
global xTrue;
u = GetRobotControl(k,Robot,it);
xTrue = Robot.q(it,:)';
xTrue(3) = AngleWrapping(xTrue(3));
end