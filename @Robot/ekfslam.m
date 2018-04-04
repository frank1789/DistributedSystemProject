function this = ekfslam(this, it)
%ekfslam
% @param[in] it = index of time
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
    % inititialize matrix uncertainty
    C_l_rho_theta = diag([this.laser_rho_sigma^2, this.laser_theta_sigma^2]);
    CovMatMeas = [];
    H = [];
    Z = [];
    TR = [];
    TT = [];
%     if it >= 4 && ~isempty(this.laserScan_2_xy{it})
%         %Rnew = this.laserScan_2_xy(~cellfun(@isempty, this.laserScan_2_xy));
%         %
%         %         if rand(1) > Noise.Camera.ProbFailure && not(isnan(Sensor.Camera.Noisyq_m{j}(1, i)))
%         Hj = eye(3);
%         CovMatj = C_l_rho_theta;
%         
%         %compute icp
%         q = zeros(3,length(this.laserScan_2_xy{it}));
%         q(1:2,:) = this.laserScan_2_xy{it};
%         p = zeros(3,length(this.laserScan_2_xy{it}));
%         p(1:2,:) = this.laserScan_2_xy{it-2};
%         p(isnan(p))=0;
%         q(isnan(q))=0;
%         [TR, TT, ER, t] = icp(q,p);
%      
%         
%         
%         
%         %Zj = [this.laserScan_2_xy{it}; zeros(1,length(this.laserScan_2_xy{it}))]'* TR + TT';
%         Zj = [pdist(this.laserScan_2_xy{it}), atan2(this.laserScan_2_xy{it}(2,:),this.laserScan_2_xy{it}(1,:))];
%         %             Zj = Sensor.Camera.Noisyq_m{j}(:, i);
%         %             % Stack together the measures
%         H = [H; Hj];
%         CovMatMeas = blkdiag(CovMatMeas, CovMatj);
%         Z = [Z; Zj];
%     end
    %     end
    % If there are available measures
    if not(isempty(H))
        % Kalmn gain
%        K = P_p * H' * inv(H * P_p * H' + CovMatMeas);
        % Update state estimate
%        this.EKF_q_est = q_est_p + K * (Z' - H * q_est_p);
        % Update the covariance
       % this.EKF_P = (eye(3) * eps - K * H) * P_p;
    else
        this.EKF_q_est = q_est_p;
        this.EKF_P = P_p;
    end
end
% store
this.EKF_q_store(:,it) = this.EKF_q_est(:,1);
end % function