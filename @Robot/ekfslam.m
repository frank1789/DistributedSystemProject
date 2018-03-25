function this = ekfslam(this, it)

if it < 2
    this.EKF_q_est = this.q(it,:)';
else
    % Prediction
    DeltaEnc = [this.noisyRightEnc(it) - this.noisyRightEnc(it-1);
        this.noisyLeftEnc(it) - this.noisyLeftEnc(it-1)]; % Angle increments
    
    A = [1 0 -sin(this.EKF_q_est(3))*this.wheelradius/2*(DeltaEnc(1) + DeltaEnc(2));
         0 1 cos(this.EKF_q_est(3))*this.wheelradius/2*(DeltaEnc(1) + DeltaEnc(2));
         0 0 1];
    B = [cos(this.EKF_q_est(3))*this.wheelradius/2, cos(this.EKF_q_est(3))*this.wheelradius/2;
         sin(this.EKF_q_est(3))*this.wheelradius/2, sin(this.EKF_q_est(3))*this.wheelradius/2;
         this.wheelradius/this.interaxle, -this.wheelradius/this.interaxle];
    
    q_est_p = this.EKF_q_est + B * DeltaEnc;
    P_p = A * this.EKF_P * A' + B * this.EKF_Q * B';
    
    
    % Update
    % Measures
    CovMatMeas = [];
    H = [];
    Z = [];
%     for j=1:size(Noise.Camera.Pos,1)
%         
%         if rand(1) > Noise.Camera.ProbFailure && not(isnan(Sensor.Camera.Noisyq_m{j}(1, i)))
%             Hj = eye(3);
%             CovMatj = Noise.Camera.Rc;
%             Zj = Sensor.Camera.Noisyq_m{j}(:, i);
%             
%             % Stack together the measures
%             H = [H; Hj];
%             CovMatMeas = blkdiag(CovMatMeas, CovMatj);
%             Z = [Z; Zj];
%         end
        
%     end
    
    % If there are available measures
    if not(isempty(H))
        % Kalmn gain
        K = P_p*H'*inv(H*P_p*H' + CovMatMeas);
        
        % Update state estimate
        this.EKF_q_est = q_est_p + K * (Z - H * q_est_p);
        
        % Update the covariance
       this.EKF_P = (eye(3) * eps - K * H) * P_p;
    else
        this.EKF_q_est = q_est_p;
        this.EKF_P = P_p;
    end
end
    % Store
    this.EKF_q_store(:,it) = this.EKF_q_est;

end % function