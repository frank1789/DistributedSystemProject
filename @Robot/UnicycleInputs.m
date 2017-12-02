function [v, omega] = UnicycleInputs(t, pdistance, ptheta)
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

% persistent angle
% 
% if ptheta ~= 0
%     angle = ptheta;
% end

%     persistent theta_u
%    theta_u = [4 -6]; % target[x y]
if pdistance > 1 || isnan(pdistance)
    v = 2 * ones(length(t),1);    % [m/s]
    omega = zeros(length(t),1); % [rad/s]
else % ACTUALLY STOP
    
    v =  0 * ones(length(t),1); % [m/s]
    omega = ((ptheta * ones(length(t),1))./t);% [rad/s]
end
% fprintf('actual speed:\t%.5f m/s; omega = \t%.5f\n', v, omega);

end % method