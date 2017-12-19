function [v, omega] = UnicycleInputs(t, ptheta)
%UNICYCLEINPUTS the method used in the calculation of the robot kinematics
% calculates the speed and rotation. Integrates a condition to avoid
% obstacles. 
% INPUT:
%  this (object) = refer to this object
%  ptheta (double) = steering angle
% OUTPUT:
%  v (double) = rectlinear velocity [m/s]
%  omega(double) = angular velocity [rad/s]

if ptheta == 0
    v = 2 * ones(length(t),1);    % [m/s]
    omega = zeros(length(t),1);% [rad/s]
else % ACTUALLY STOP
    
    v =   zeros(length(t),1); % [m/s]
    omega = ptheta * ones(length(t),1);% [rad/s]
end
% fprintf('actual speed:\t%.5f m/s; omega = \t%.5f\n', v, omega);


end % method