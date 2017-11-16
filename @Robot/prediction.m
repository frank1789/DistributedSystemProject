%% Prediction
function this = prediction(this, i)
%PREDICTION function to estimate the new position and orientation of robot in EKF algortihm
% INPUT:
%  this = refer to this object
%  i = iterator from cycle
% OUTPUT: none

% set local variable form class
Sensor.Enc.NoisyRight = this.quatizeffect_RightEnc;
Sensor.Enc.NoisyLeft = this.quatizeffect_LeftEnc;

% Angle increments
DeltaEnc = [Sensor.Enc.NoisyRight(i) - Sensor.Enc.NoisyRight(i-1);
            Sensor.Enc.NoisyLeft(i) - Sensor.Enc.NoisyLeft(i-1)];

A = [1 0 -sin(this.EKF_q_est(3))*this.wheelradius/2*(DeltaEnc(1) + DeltaEnc(2));
     0 1 cos(this.EKF_q_est(3))*this.wheelradius/2*(DeltaEnc(1) + DeltaEnc(2));
     0 0 1];
B = [cos(this.EKF_q_est(3))*this.wheelradius/2, cos(this.EKF_q_est(3))*this.wheelradius/2;
     sin(this.EKF_q_est(3))*this.wheelradius/2, sin(this.EKF_q_est(3))*this.wheelradius/2;
     this.wheelradius/this.interaxle, -this.wheelradius/this.interaxle];

this.q_est_p = this.EKF_q_est + B * DeltaEnc;
this.P_p = A * this.EKF_p * A' + B * this.EKF_Q * B';

% delete local variable
clear Sensor

end
