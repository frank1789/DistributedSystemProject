function this = UnicycleKinematicMatlab(this)



% Unicycle dynamic
[this.t, this.q] = ode45(@(t,y) this.UnicycleModel(t, y), this.t, this.q);

% Input sequence
[v, omega] = this.UnicycleInputs(this.t);
this.u = [v'; omega'];
end
