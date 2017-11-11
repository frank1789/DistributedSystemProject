function this = UnicycleKinematicMatlab(this, MdlInit, Vehicle)

% Simulation set-up
Dt = MdlInit.Ts;
this.t = 0:Dt:MdlInit.T;

% Unicycle dynamic
[this.t, this.q] = ode45(@(t,y) this.UnicycleModel(t,y), this.t, Vehicle.q0);

% Input sequence
[v, omega] = this.UnicycleInputs(this.t);
this.u = [v'; omega'];
end