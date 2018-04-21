function odometry = setOdometry(this, Robot, it)
%SETODOMETRY perfrom the odometry simulation from Robot's encoder.
%
%  compute the difference both encoder e return delta angle increment
% next compute the geometric parameters of robot and store the update postion
% return the odometry value
%
%@param[in] Robot - class Robot
%@param[in] it - index of time simulation
%@param[out] odometry - displacement ododmetry measure

DeltaEnc = [Robot.noisyRightEnc(it) - Robot.noisyRightEnc(it-1);
    Robot.noisyLeftEnc(it) - Robot.noisyLeftEnc(it-1)]; % Angle increments

B = [cos(Robot.EKF_q_est(3))*Robot.wheelradius/2, cos(Robot.EKF_q_est(3))*Robot.wheelradius/2;
    sin(Robot.EKF_q_est(3))*Robot.wheelradius/2, sin(Robot.EKF_q_est(3))*Robot.wheelradius/2;
    Robot.wheelradius/Robot.interaxle, -Robot.wheelradius/Robot.interaxle];

this.qEst = this.qEst + B * DeltaEnc;
odometry = this.qEst;
end
