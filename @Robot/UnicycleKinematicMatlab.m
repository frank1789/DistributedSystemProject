function this = UnicycleKinematicMatlab(this, piterator)
% % UNICYCLEKINEMATICMATLAB a method that calculates the kinematics and
% dynamics of the Robot model.
% @detail The ode45 function calculates the dynamics of the model by having the
% input position and time and reference to the step to be calculated.
% Then save the last position and time in their respective class properties.
% Call up the method to calculate the unicode model inputs by retrieving the
% velocity vector. Finally, it simulates the encoders.
% INPUT:
% @param [in] it = step of simulation

t1 = this.t;
q = this.q;
% Unicycle dynamic
[t1, q] = ode45(@(t, y, it) this.UnicycleModel(t, y, piterator), [t1(end) t1(end)+0.05], q(end,:));
q(end,3) = wrapToPi(q(end,3));
this.q(end+1,:) = q(end,:); % store last row of solution - postion
this.t(end+1) = t1(end);    % store last row of solution - time
% Input sequence
[v, omega] = this.UnicycleInputs(this.t, this.speed, this.steerangle);
this.u = [v'; omega']; % store vector of velocity
this.EncoderSim();     % perform encoder simulation
end % method
