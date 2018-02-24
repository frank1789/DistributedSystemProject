clear all;
clc;

%% Simulation set-up

% Sampling time
MdlInit.Ts = 0.05;

% Length of simulation
MdlInit.T = 10;


%% Vehicle set-up

% Vehicle initital condition
Vehicle.q0 = [0; 1; pi/4];

% Vehicle wheel radius
Vehicle.R = 0.15;

% Vehicle inter-axle
Vehicle.L = 0.56;

% Actual unicycle simulation in Matlab, with trajectory returned with a
% sampling time 'MdlInit.Ts'
[q, t, u] = UnicycleKinematicMatlab(MdlInit, Vehicle);


%% Noises

% Encoder quantization
Noise.Enc.Quanta = 2*pi/2600;

% Encoder noise
Noise.Enc.mu = 0;
Noise.Enc.sigma = 2*Noise.Enc.Quanta/3;

% Camera positions
Noise.Camera.Pos = [-10, 10; 10, 10; 10, -10; -10, -10];
Noise.Camera.MaxRange = 15;

% Camera noise
Noise.Camera.mu = zeros(3,1);
Noise.Camera.MaxPosError = 0.5;
Noise.Camera.MaxOrError = 9/180*pi;
Noise.Camera.Rc = diag([(Noise.Camera.MaxPosError/3)^2, (Noise.Camera.MaxPosError/3)^2, (Noise.Camera.MaxOrError/3)^2]);

% Probability of image acquisition failure
Noise.Camera.ProbFailure = 0.95;


%% Sensor simulation

% Encoders
[Sensor.Enc.Right, Sensor.Enc.Left] = EncoderSim(u, t, Vehicle);

% Noisy encoders
[Sensor.Enc.NoisyRight, Sensor.Enc.NoisyLeft] = EncoderNoise(Sensor, Noise);

% Surveillance cameras
[Sensor.Camera.q_m] = CameraSim(q);

% Surveillance noisy cameras
[Sensor.Camera.Noisyq_m] = CameraNoise(q, Noise);

%% EKF

% EKF init
EKF.q_est = zeros(3,1);
EKF.P = 1e2*eye(3);
EKF.Q = diag([Noise.Enc.sigma^2, Noise.Enc.sigma^2]);
EKF.R = Noise.Camera.Rc;

% Number of samples
EKF.NumS = length(t);
EKF.q_store = zeros(3,EKF.NumS);
EKF.q_store(:,1) = EKF.q_est;

for i=2:EKF.NumS
    
    %% Prediction
    
    % Angle increments
    DeltaEnc = [Sensor.Enc.NoisyRight(i) - Sensor.Enc.NoisyRight(i-1);
        Sensor.Enc.NoisyLeft(i) - Sensor.Enc.NoisyLeft(i-1)];
    
    A = [1 0 -sin(EKF.q_est(3))*Vehicle.R/2*(DeltaEnc(1) + DeltaEnc(2));
        0 1 cos(EKF.q_est(3))*Vehicle.R/2*(DeltaEnc(1) + DeltaEnc(2));
        0 0 1];
    B = [cos(EKF.q_est(3))*Vehicle.R/2, cos(EKF.q_est(3))*Vehicle.R/2;
        sin(EKF.q_est(3))*Vehicle.R/2, sin(EKF.q_est(3))*Vehicle.R/2;
        Vehicle.R/Vehicle.L, -Vehicle.R/Vehicle.L];
    
    q_est_p = EKF.q_est + B*DeltaEnc;
    P_p = A*EKF.P*A' + B*EKF.Q*B';
    
    
    %% Update
    
    % Measures
    CovMatMeas = [];
    H = [];
    Z = [];
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
    
    % If there are available measures
    if not(isempty(H))
        % Kalmn gain
        K = P_p*H'*inv(H*P_p*H' + CovMatMeas);
        
        % Update state estimate
        EKF.q_est = q_est_p + K*(Z - H*q_est_p);
        
        % Update the covariance
        EKF.P = (eye(3) - K*H)*P_p;
    else
        EKF.q_est = q_est_p;
        EKF.P = P_p;
    end
    
    % Store
    EKF.q_store(:,i) = EKF.q_est;
end

%% Plot

% Plot unicycle
PlotUnicycle(q(:,1)', q(:,2)', q(:,3)', EKF.q_store(1,:), EKF.q_store(2,:), EKF.q_store(3,:), EKF.q_store(1,:), EKF.q_store(2,:), EKF.q_store(3,:), t);

figure(2), clf, hold on;
plot(t, EKF.q_store(1,:) - q(:,1)')
xlabel('[s]'); ylabel('e_x');

figure(3), clf, hold on;
plot(t, EKF.q_store(2,:) - q(:,2)')
xlabel('[s]'); ylabel('e_y');

figure(4), clf, hold on;
plot(t, EKF.q_store(3,:) - q(:,3)')
xlabel('[s]'); ylabel('e_{\theta}');


