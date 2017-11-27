function dy = UnicycleModel(this, t, y, piterator)
% disp(piterator)
% Input parser
xu = y(1);
yu = y(2);
thetau = y(3);
% a = cell2mat(this.distance{piterator});
if ~isempty(this.distance)
    if piterator > 1
        disp(piterator)
        if ~isempty(this.distance{piterator})
        mindistance = min(this.distance{piterator})
        end
    end
end


% c = find(this.q == this.q(end,:));
[v, omega] = this.UnicycleInputs(t, 0);

% System kinematic
xu_d = cos(thetau)*v;
yu_d = sin(thetau)*v;
thetau_d = omega;

% Output
dy = [xu_d; yu_d; thetau_d];
end