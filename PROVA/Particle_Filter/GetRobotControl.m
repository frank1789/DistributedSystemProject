function u = GetRobotControl(k)
global nSteps;
u = [0; 0.025 ; 0.1* pi/180*sin(3*pi*k/nSteps)];
end