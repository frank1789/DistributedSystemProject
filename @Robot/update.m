function this = update(this, i)
%UPDATE method
% INPUT:
%  this = refer to this object
%  i = iterator from cycle
% OUTPUT: none
% Measures
CovMatMeas = [];
H = [];
Z = [];
%{
for j=1:size(Noise.Camera.Pos,1)

    if rand(1) > Noise.Camera.ProbFailure && not(isnan(Sensor.Camera.Noisyq_m{j}(1, i)))
        Hj = eye(3);
        CovMatj = Noise.Camera.Rc;
        Zj = Sensor.Camera.Noisyq_m{j}(:, i);

        % Stack together the measures
        H = [H; Hj];
        CovMatMeas = blkdiag(CovMatMeas, CovMatj);
        Z = [Z; Zj];
    end

end
%}

% If there are available measures
if not(isempty(H))
    % Kalman gain
    K = this.P_p * H'* inv(H * this. P_p * H' + CovMatMeas);
    
    % Update state estimate
    this.EKF_q_est = this.q_est_p + K * (Z - H * this.q_est_p);
    
    % Update the covariance
    this.EKF_p = (eye(3) - K*H)*P_p;
else
    this.EKF_q_est = this.q_est_p;
    this.EKF_P = this.P_p;
end

end
