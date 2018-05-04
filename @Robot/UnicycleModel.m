function dy = UnicycleModel(this, t, y, it)
% UNICYCLEMODEL parse the position, then use the potential field to compute the
% trajectory for point target and avoid obstacle.
% @param [in] t: time
% @param [in] y: position
% @param [in] it: iteration
% @param [out] dy: increment displacement

% Input parser
xu = y(1);
yu = y(2);
thetau = y(3);
% run potential field - path planning & avoid obstacle
if ~isempty(this.laserScan_xy{it})
    % compute the laserscan in word frame
    R = this.rotationMatrix(this.q(it,3)); % apply rotation matrix
    % global frame
    rotatescan = [this.laserScan_xy{it}(2,:).*cos(this.laserTheta);...
        this.laserScan_xy{it}(2,:).*sin(this.laserTheta)]' / R + [this.q(it,1); this.q(it,2)]';
    % check if reach target
    if sqrt((this.target(1) - xu)^2 + (this.target(2) - yu)^2) > 0.05
        [this.steerangle] = potentialfield([xu yu thetau], ...
            this.target,rotatescan', this.laserTheta, this.speed);
        if abs(this.steerangle) < 1e-3
            this.steerangle = 0;
            this.speed = 2;
        else
             this.speed = 0.5; % reduce speed
        end
        this.steerangle = wrapToPi(this.steerangle);
    else
        this.speed = 0;
        this.steerangle = 0.0;
    end
end
[v, omega] = this.UnicycleInputs(t, this.speed, this.steerangle);
% system kinematic
xu_d = cos(thetau) * v;
yu_d = sin(thetau) * v;
thetau_d = omega;
dy = [xu_d; yu_d; thetau_d]; % return value
end % method
