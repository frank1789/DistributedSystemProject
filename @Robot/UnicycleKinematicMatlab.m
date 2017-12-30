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

persistent t1 q laststeer; % allocate static varible to perform ode45
if isempty(t1) && isempty(q) % check if void, otherwise it takes last solution ode45
    t1 = this.t;
    q = this.q;
%     laststeer =this.steerangle;
end

% if ~isempty(this.distance{piterator})
% [laststeer] = passadati(this.q(end,:),this.target,this.distance{piterator},this.laserTheta, 2); 
% end
% fprintf('iter: %i; angolo di sterzo nuovo: %5.5f\n', piterator,laststeer);
% if laststeer > this.steerangle || laststeer < this.steerangle
%     this.steerangle = laststeer;
% elseif ~isempty(find((q(:,3) - this.steerangle) < 1e-6 == true))
%      this.steerangle = 0;
% end
% for i = 1:length(q)
% j = find((q(:,3) - this.steerangle)< 1e-6);
% end
% fprintf('iter: %i; angolo di sterzo: %5.5f\n', piterator,this.steerangle);

%this.detectangle(piterator);
% flag = find((q(:,3) - this.steerangle) < 1e-6 == true);
% switch ~isempty(flag)
%     case false
        % Unicycle dynamic
        opts = odeset('Refine',5);
        [t1, q] = ode45(@(t, y,it) this.UnicycleModel(t, y,piterator), [t1(end) t1(end)+this.Dt], q(end,:), opts);
        q(end,3) = wrapToPi(q(end,3));
        this.q(end+1,:) = q(end,:); % store last row of solution - postion
        this.t(end+1) = t1(end);    % store last row of solution - time
        
         
%     case true
%         % check minimun distance from obstacle
%         
%         % Unicycle dynamic
%         [t1, q] = ode45(@(t, y,it) this.UnicycleModel(t, y, piterator), [t1(end) t1(end)+0.05], q(end,:));
%         q(end,3) = wrapToPi(q(end,3));
%         this.q(end+1,:) = q(end,:); % store last row of solution - postion
%         this.t(end+1) = t1(end);    % store last row of solution - time
%         this.steerangle = 0;
% end


% Input sequence
[v, omega] = this.UnicycleInputs(this.t, this.steerangle);
this.u = [v'; omega']; % store vector of velocity
this.EncoderSim(); % perform encoder simulation
end % method
