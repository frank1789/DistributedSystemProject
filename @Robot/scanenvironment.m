function this = scanenvironment(this, ppoints, plines, it)
%SCANENVIROMENT method that performs environmental scanning by simulation
% of LIDAR.
% Calculates distance from the robot center, then from the position
% coordinates currently occupied by the robot, position X, Y and Theta
% orientation.
% The scan is performed at 180 degrees with a preset angular resolution.
% In addition, the visual field is between 0 and 4 [m] outside this range
% and returns a NaN value.
% Scanning of points is saved in the variable class properties.
%  @param [in] ppoint = points on map that generate the plant of enviroment
%  @param [in] plines = lines that connect the point of enviroment

% set postion [x, y, theta]
initposition = [this.q(it,1), this.q(it,2) this.q(it,3)];
% initialize laser beam
laser = [initposition, pi, this.laserAngularResolution*pi/180,...
    this.laser_theta_sigma, this.laser_rho_sigma] ;
% scan environment
laserReadings = Sens_model_noise(ppoints, plines, laser(1,:));
% remove the data that are too far away
rhosOver4m = (laserReadings(2,:) < this.lasermaxdistance & laserReadings(2,:) > this.lasermindistance);
laserReadings(2,:) = laserReadings(2,:).* rhosOver4m; % set zero value over max distance
% remove outliers
F = laserReadings(2,:); % instance a temporary F matrix
F(rhosOver4m==0)=nan;   % substitute 0 with nan
laserReadings(2,:)= F;  % update original matrix of scan
% store raw data scan - robot frame
this.laserScan_xy{it} =[laserReadings(2,:).*cos(this.laserTheta);... 
    laserReadings(2,:).*sin(this.laserTheta)];  
end % method
