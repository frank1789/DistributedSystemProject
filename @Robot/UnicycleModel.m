function dy = UnicycleModel(this, t, y, it)
% UNICYCLEMODEL
% @Details: parse the position, then use the potential field to compute the
% trajectory for point target and avoid obstacle.
% @param [in] t
% @param [in] y
% @param [in] it
% @param [out] dy

% Input parser
xu = y(1);
yu = y(2);
thetau = y(3);
% run potential field - path planning & avoid obstacle
if ~isempty(this.laserScan_xy{it})
    % check if reach target
    if sqrt((this.target(1) - xu)^2 + (this.target(2) - yu)^2) > 0.05
        [this.steerangle] = potentialfield([xu yu thetau],this.target,this.laserScan_xy{it},this.laserTheta, this.speed);
        if abs(this.steerangle) < 1e-3
            this.steerangle = 0;
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
