classdef Robot < handle
    %ROBOT Summary of this class goes here
    %   Detailed explanation goes here
    
    % Vehicle property
    properties (Constant)%, Access = private)
        wheelradius = 0.15; % dimension of whell [m]
        interaxle = 0.56;   % dimension of interaxle[m] |---|
        length  = 1;    % data for drawing
        width   = 1;    % data for drawing
    end
    
    % Physical quantities
    properties% (Access = private)
        ID;     % Name of the robot
        t = []; % time [s]
        q = []; % position [m]
        u = []; % velocity vector [rectilinear[m/s] angular[rad/s]]
    end
    
    % Virtual incremental encoder
    properties (Constant)
        enc_quantization = 2 * (pi / 2600);   % encoder quantization
        % encoder noise
        enc_mu = 0;                           % mean
        enc_sigma = 2 * (2 * pi / 2600) / 3;  % variance
    end
    
    properties
        RightEnc = []; % right encoder values
        LeftEnc = [];  % left encoder values
        % Quantization effect
        quatizeffect_LeftEnc = [];  % right encoder measure
        quatizeffect_RightEnc = []; % left encoder measure
    end
    
    % EKF quantities
    properties
        EKF_q_est;      % position estimation
        EKF_P;
        EKF_Q;
        EKF_NumS;       % step
        EKF_q_store;    % position data stored
        q_est_p;
        P_p;
    end
    
    % definition laser sensor
    properties (Constant)
        laserAngularResolution = 0.36;  % [deg] laser sensor parameters
        lasermaxdistance = 4;           % [m]   laser sensor parameters
        % noise
        laser_rho_sigma     = 0.1;              % mean
        laser_theta_sigma   = 0.1 * (pi / 180); % variance
    end
    
    properties
        C_l_xy = {};
        laserScan_xy = cell.empty; % contains scans at a certain location
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
            this.EKF_P = 1e2 * eye(3);
            this.EKF_Q = diag([this.enc_sigma^2, this.enc_sigma^2]);
            this.EKF_NumS = length(this.t);
            this.EKF_q_store = zeros(3, this.EKF_NumS);
            this.EKF_q_store(:,1) = this.EKF_q_est;
        end % definition constructor
        
        % function to compute the kinematics
        % Kinematic simulation
        this = UnicycleKinematicMatlab(this, MdlInit, Vehicle);
        dy = UnicycleModel(this, t, y);
        
        % Encoder Simulation
        this = EncoderSim(this, Vehicle);
        this = EncoderNoise(this);
        
        % function to compute Extend Kalman Filter
        this = prediciton(this, i);
        this = update(this, i);
        this = store(this, i);
        
        % plot function
        [body, label, rf_x, rf_y, rf_z] = makerobot(this, t);
        [body, label, rf_x, rf_y, rf_z] = animate(this, it);
        
        % getter method to access proprerty class
        numsteps = getEKFstep(this)
        
        % method to comupte laser scansion of the environment
        this = scanenvironment(this, ppoints, plines, it);
        [laserScan_xy] = getlaserscan(this, it);
        [laserbeam] = plotlaserbeam(this, t)
        [newy] = endY(this, it, angle);
        [newX] = endX(this, it, angle);
        [laserbeam] = animatelaser(this, t) 
        getplot(this);
        [occupacygrid] = getoccupacygrid(this, it)
    end
    
    methods (Static)
        [v, omega] = UnicycleInputs(t) % Kinematic simulation
        [R] = rotationMatrix(theta)    % compute rotation matrix in plane 2D
    end
end % definition class
