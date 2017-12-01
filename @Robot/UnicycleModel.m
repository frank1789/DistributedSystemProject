function dy = UnicycleModel(this, t, y, piterator)

% Input parser
xu = y(1);
yu = y(2);
thetau = y(3);

% mindistance = 0.85;
if ~isempty(this.distance{piterator})
    this.mindistance = min(this.distance{piterator});
    fprintf('check distance: %f\n', this.mindistance);
end

[v, omega] = this.UnicycleInputs(t, this.mindistance);

% System kinematic
xu_d = cos(thetau)*v;
yu_d = sin(thetau)*v;
thetau_d = omega;

% Output
dy = [xu_d; yu_d; thetau_d];
end % method