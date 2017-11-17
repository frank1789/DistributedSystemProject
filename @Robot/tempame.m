function this = tempame(this, ppoints, plines, it)
% fprintf('time:%3.4f\n',this.t(it))
% fprintf('@ 10z\n')
update = mod(this.t(it), 0.1);
if ~update
    fprintf('inside laser time:%3.4f\n',this.t(it))

% initialize initial postion
initposition = [this.q(it,1), this.q(it,2) this.q(it,3)]; % [position x, y, theta]

% initialize sector of angle laser theta
laserTheta = pi/180*( -90 : this.laserAngularResolution : 90 );

% inititialize matrix uncertainty
C_l_rho_theta = diag([this.laser_rho_sigma^2, this.laser_theta_sigma^2]);

% initialize laser beam
laser = [ initposition, pi, this.laserAngularResolution*pi/180,...
    this.laser_theta_sigma, this.laser_rho_sigma ] ;

% scan environment
laserReadings = Sens_model_noise( ppoints, plines, laser(1,:));
fprintf('poisition x:%3.3f; y:%3.3f; theta:%3.3f; laser:%3.3f, %3.3f, %3.3f\n', this.q(it,1),this.q(it,2),this.q(it,3),laserReadings(1:3))


% remove the data that are too far away
rhosOver4m = laserReadings(2,:) > this.lasermaxdistance;

this.laserScan_xy{it} =[ laserReadings(2,:).*cos(laserTheta);...
    laserReadings(2,:).*sin(laserTheta) ];
end
end
