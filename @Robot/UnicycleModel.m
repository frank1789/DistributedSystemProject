function dy = UnicycleModel(this, t, y, piterator)

% Input parser
xu = y(1);
yu = y(2);
thetau = y(3);
if ~isempty(this.distance{piterator})
[this.steerangle] = passadati([xu yu thetau],this.target,this.distance{piterator},this.laserTheta, 4); 
fprintf("it: %3i, %5.5f\n",piterator,this.steerangle)
end

[v, omega] = this.UnicycleInputs(t, this.steerangle);

% System kinematic
xu_d = cos(thetau) * v;
yu_d = sin(thetau) * v;
thetau_d = omega;

% Output
dy = [xu_d; yu_d; thetau_d];
end % method