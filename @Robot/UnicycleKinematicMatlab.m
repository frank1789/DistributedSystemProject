function this = UnicycleKinematicMatlab(this, piterator)
% UNICYCLEKINEMATICMATLAB a method that calculates the kinematics and
% dynamics of the Robot model.
% In detail: two static variables are declared, which are the position and
% the time, and if they are checked if they are empty, they assume the last
% configuration calculated in ode45.
% The ode45 function calculates the dynamics of the model by having the input
% position and time and reference to the step to be calculated in order to
% obtain obstacles.
% Then save the last position and time in their respective class properties.
% Call up the method to calculate the unicode model inputs by retrieving the velocity vector.
% Finally, it simulates the encoders.
% INPUT:
%  this (object) = refer to this object
%  piterator (int) = step of simulation
% OUTPUT:
%  this(object) = refer to this object
%  t(double) = last row of time computed by ode45 [n, m]
%  q(double) = last row of time computed by ode45 [n, m]

persistent t1 q; % allocate static varible to perform ode45
if isempty(t1) && isempty(q) % check if void, otherwise it takes last solution ode45
    t1 = this.t;
    q = this.q;
end

% check minimun distance from obstacle
this.detectangle(piterator);


% Unicycle dynamic
[t1, q] = ode45(@(t, y) this.UnicycleModel(t, y), [t1(end) t1(end)+0.05], q(end,:));
this.q(end+1,:) = q(end,:); % store last row of solution - postion
this.t(end+1) = t1(end);    % store last row of solution - time

% Input sequence
[v, omega] = this.UnicycleInputs(this.t, this.steerangle);
this.u = [v'; omega']; % store vector of velocity
this.EncoderSim(); % perform encoder simulation
end % method
