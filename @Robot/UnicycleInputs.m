function [v, omega] = UnicycleInputs(t, pdistance)
% disp(pdistance)
v = 1*ones(length(t),1);    % [m/s]
% v = zeros(length(t),1);
% fprintf('actual speed:\t%.5f m/s\n', v);
% omega = 2*sin(2*pi*t/10).*cos(2*pi*t/2); % [rad/s]
 omega = zeros(length(t),1);
end