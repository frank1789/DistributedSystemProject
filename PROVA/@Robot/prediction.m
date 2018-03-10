%% Prediction
function this = prediction(this, it)
%PREDICTION function to estimate the new position and orientation of robot in EKF algortihm
% @param [in] i = iterator from cycle

% set local variable form class
Sensor.Enc.NoisyRight = this.quatizeffect_RightEnc;
Sensor.Enc.NoisyLeft = this.quatizeffect_LeftEnc;

% Angle increments
DeltaEnc = [Sensor.Enc.NoisyRight(it) - Sensor.Enc.NoisyRight(it-1);
            Sensor.Enc.NoisyLeft(it) - Sensor.Enc.NoisyLeft(it-1)];

A = [1 0 -sin(this.EKF_q_est(3))*this.wheelradius/2*(DeltaEnc(1) + DeltaEnc(2));
     0 1 cos(this.EKF_q_est(3))*this.wheelradius/2*(DeltaEnc(1) + DeltaEnc(2));
     0 0 1];
B = [cos(this.EKF_q_est(3))*this.wheelradius/2, cos(this.EKF_q_est(3))*this.wheelradius/2;
     sin(this.EKF_q_est(3))*this.wheelradius/2, sin(this.EKF_q_est(3))*this.wheelradius/2;
     this.wheelradius/this.interaxle, -this.wheelradius/this.interaxle];

this.q_est_p = this.EKF_q_est + B * DeltaEnc;
this.P_p = A * this.EKF_P * A' + B * this.EKF_Q * B';

% delete local variable
clear Sensor A B

end