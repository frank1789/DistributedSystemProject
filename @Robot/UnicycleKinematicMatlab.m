function this = UnicycleKinematicMatlab(this, it)

% t = 0:MdlInit.Ts:MdlInit.T;
% 
% y1 = [0, 0, 0];
% 
% t1 = 0;
% 
% y=zeros(1,3);
% 
% for i = 1:1:nit
%     [t1, y1] = ode45(@(t,y) UnicycleModel(t, y), [t1(end) t1(end)+MdlInit.Ts], y1(end,:));
%     y(end+1:end+length(y1(:,1)),:)= y1;
% end
persistent t1 q;

if isempty(t1)
    t1 = 0;
end
if isempty(q)
    q = this.q;
end


% Unicycle dynamic
[t1, q] = ode45(@(t,y) this.UnicycleModel(t, y), [t1(end) t1(end)+0.05], q(end,:));
this.q(end+1:end+length(q(:,1)),:) = q;
this.t(end+1:end+length(t1(:,1))) = t1;

% Input sequence
[v, omega] = this.UnicycleInputs(this.t);
this.u = [v'; omega'];
end
