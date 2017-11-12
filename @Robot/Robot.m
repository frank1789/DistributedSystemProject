classdef Robot < handle
    %ROBOTMODEL Summary of this class goes here
    %   Detailed explanation goes here
    
    properties (Constant)%, Access = private)
        % Vehicle property
        wheelradius = 0.15; % dimension of whell [m]
        interaxle = 0.56;   % dimension of interaxle[m] |---|
        
        % Encoder quantization
        enc_quantization = 2 * pi / 2600;
        % encoder noise
        enc_mu = 0;                           % mean
        enc_sigma = 2 * (2 * pi / 2600) / 3;  % variance
        
        
        % drawing
        length  = 1;
        width   = 1;
    end

    properties% (Access = private)

        ID;

        t = [];
        q = [];
        u = [];
        % Encoder values
        RightEnc;
        LeftEnc;
        % Quantization effect
        quatizeffect_LeftEnc;
        quatizeffect_RightEnc;

        % EKF
        EKF_q_est;
        EKF_p;
        EKF_Q;
        EKF_NumS;
        EKF_q_store;
        q_est_p;
        P_p

    end

    methods
        % class constructor
        function this = Robot(inputID, time, sampletime, initialposition)
            % initialize identification number of robot
            this.ID = inputID;
            fprintf('Initialize robot n: %3i\n', this.ID);

            % initialize simulation time and sample
            Dt = sampletime;     % Sampling time
            this.t = 0:Dt:time;  % Length of simulation
            
            % set initial position
            this.q = initialposition;

            % initialize Extend Kalman Filter aka EKF
            this.EKF_q_est = zeros(3,1);
            this.EKF_p = 1e2 * eye(3);
            this.EKF_Q = diag([this.enc_sigma^2, this.enc_sigma^2]);
            this.EKF_NumS = length(this.t);
            this.EKF_q_store = zeros(3, this.EKF_NumS);
            this.EKF_q_store(:,1) = this.EKF_q_est;
        end

        % function to compute the kinematics
        % Kinematic simulation
        this = UnicycleKinematicMatlab(this, MdlInit, Vehicle)
        dy = UnicycleModel(this, t,y)
        
        % Encoder Simulation
        this = EncoderSim(this, Vehicle)
        this = EncoderNoise(this)

        % function to compute Extend Kalman Filter
        this = prediciton(this,i)
        this = update(this,i)
        this = store(this,i)
        
        % plot function
        makerobot(this,vehicle)
        
        % getter method to access proprerty class 
        numsteps = getEKFstep(this)
        
    end

    methods (Static)
        % Kinematic simulation
        [v, omega] = UnicycleInputs(t)
    end
end
