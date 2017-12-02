function [v, omega] = UnicycleInputs(t, pdistance, target)
%UNICYCLEINPUTS the method used in the calculation of the robot kinematics
% calculates the speed and rotation. Integrates a condition to avoid
% obstacles. The minimum safety distance is 0.75 [cm], on the contrary if
% the environmental scan does not detect obstacles or places at a distance
% greater than the minimum distance it can move.
% INPUT:
%  this (object) = refer to this object
%  pdistance (double) = distance from the obstacle
% OUTPUT:
%  v (double) = rectlinear velocity [m/s]
%  omega(double) = angular velocity [rad/s]
try
    target;
catch
    
   target = [4 -6]; % target[x y]
if pdistance > 0.75 || isnan(pdistance)
    v = 0.5*ones(length(t),1);    % [m/s]
    omega = zeros(length(t),1); % [rad/s]
else % ACTUALLY STOP
    
    v = zeros(length(t),1); % [m/s]
    omega = zeros(length(t),1);% [rad/s]
end
fprintf('actual speed:\t%.5f m/s\n', v);

end % method