function [v, omega] = UnicycleInputs(t)

v = 1*ones(length(t),1);    % [m/s]
fprintf('actual speed:\t%.5f m/s\n', v);
omega = 2*sin(2*pi*t/10).*cos(2*pi*t/2); % [rad/s]
end