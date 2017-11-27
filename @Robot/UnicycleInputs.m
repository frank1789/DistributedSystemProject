function [v, omega] = UnicycleInputs(t, pdistance)
disp(pdistance)
if pdistance > 0.75 || isnan(pdistance)
    v = 2*ones(length(t),1);    % [m/s]
    omega = zeros(length(t),1);
else
    v = zeros(length(t),1);
    omega = zeros(length(t),1);
end
fprintf('actual speed:\t%.5f m/s\n', v);
% omega = 2*sin(2*pi*t/10).*cos(2*pi*t/2); % [rad/s]

end