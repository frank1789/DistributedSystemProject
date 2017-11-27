function this = UnicycleKinematicMatlab(this, piterator)

persistent t1 q;

if isempty(t1)
    t1 = 0;
end
if isempty(q)
    q = this.q;
end


% Unicycle dynamic
[t1, q] = ode45(@(t,y, it) this.UnicycleModel(t, y, piterator), [t1(end) t1(end)+0.05], q(end,:), piterator);
this.q(end+1,:) = q(end,:);
this.t(end+1) = t1(end);

% Input sequence
[v, omega] = this.UnicycleInputs(this.t);
this.u = [v'; omega'];
end
