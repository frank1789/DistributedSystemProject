function this = tempame(this, ppoints, plines, it)

% initialize initial postion
initposition = [this.q(it,1), this.q(it,2) this.q(it,3)]; %[posotion x, y, theta]
% initialize sector of angle laser theta
laserTheta = pi/180*( -90 : this.laserAngularResolution : 90 );

% inititialize matrix uncertainty
C_l_rho_theta = diag([this.laser_rho_sigma^2, this.laser_theta_sigma^2]);

% initialize laser beam
laser = [ initposition, pi, this.laserAngularResolution*pi/180,...
    this.laser_theta_sigma, this.laser_rho_sigma ] ;

laserReadings = Sens_model_noise( ppoints, plines, laser(1,:));

% remove the data that are too far away
rhosOver4m = laserReadings(2,:) > this.lasermaxdistance;

this.laserScan_xy =[ laserReadings(2,:).*cos(laserTheta);...
    laserReadings(2,:).*sin(laserTheta) ];
disp(this.laserScan_xy);
end
