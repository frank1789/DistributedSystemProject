function dy = UnicycleModel(this, t, y, piterator)

% Input parser
xu = y(1);
yu = y(2);
thetau = y(3);

[v, omega] = this.UnicycleInputs(t, this.mindistance, this.theta_t);

% System kinematic
xu_d = cos(thetau) * v;
yu_d = sin(thetau) * v;
thetau_d = omega;

% Output
dy = [xu_d; yu_d; thetau_d];
end % method