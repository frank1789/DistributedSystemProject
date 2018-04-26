classdef Robot < handle
    %ROBOT represents a differential guided robot.
    %This robot is equipped with a laser sensor placed in the center of his
    %body and equipped with an encoder on the wheels.
    %Methods for kinematics, the kalman filter extended are available.
    %Other support methods such as the transformation matrix.
    %
    % ROBOT properties:
    %         wheelradius -  dimension of whell [m]
    %         interaxle   -  dimension of interaxle [m]
    %         length -  data for drawing
    %         width  -  data for drawing
    %         ID - Name of the robot
    %         t - time [s]
    %         q - position [m]
    %         u - velocity vector [rectilinear[m/s] angular[rad/s]]
    %         Dt - increment time
    %         target - point to reach
    %         steerangle - steering agnle
    %         speed  - robot velocity
    %         enc_quantization - encoder quantization
    %         enc_mu = - mean encoder
    %         enc_sigma - variance encoder
    %         RightEnc - right encoder values
    %         LeftEnc - left encoder values
    %         noisyLeftEnc- noised right encoder measure
    %         noisyRightEnc -  noised left encoder measure
    %         EKF_q_est - position estimation
    %         EKF_P -
    %         EKF_Q - matrix of covariance
    %         EKF_q_store - position estimated stored
    %         laserAngularResolution - [deg] laser sensor parameters
    %         lasermaxdistance  -  laser sensor parameters Max FOV [m]
    %         lasermindistance - laser sensor parameters min FOV[m]
    %         laser_rho_sigma - variance length laser
    %         laser_theta_sigma -  variance angular resolution
    %         laserScan_xy - contains scans at a certain location world reference
    %         laserScan_2_xy - contains scans at a certain location robot reference
    %         mindistance - min distance to start move [m]
    %         laserTheta - theta's angle sector [rad]
    %         occgridglobal - store occupacy grid
    %
    % ROBOT methods:
    %         Robot - default constructor
    %         UnicycleKinematicMatlab - function to compute the kinematics simulation
    %         setpointtarget - set point to reach
    %         ekfslam - compute Extend Kalman Filter
    %         makerobot - plot function
    %         animate - plot function for animation
    %         scanenvironment - comupte laser scansion of the environment
    %         getlaserscan - get the scans
    %         setOccupacygridglobal -  store local occupacy grid in robot
    %         getOccupacygridglobal - get occupacy grid from robot
    
    % Vehicle property
    properties (Constant)
        wheelradius = 0.07; % dimension of whell [m]
        interaxle = 0.30;   % dimension of interaxle [m]
        length  = 1/3;    % data for drawing
        width   = 1/3;    % data for drawing
    end
    % Physical quantities
    properties (SetAccess = private, Hidden = false)
        ID;     % Name of the robot
        t = []; % time [s]
        q = []; % position [m]
        u = []; % velocity vector [rectilinear[m/s] angular[rad/s]]
        Dt =[];
        target = [];
        steerangle =[];
        speed = 0.5;
    end
    % Virtual incremental encoder
    properties (Constant)
        enc_quantization = 2 * (pi / 2600);   % encoder quantization
        % encoder noise
        enc_mu = 0;                           % mean
        enc_sigma = 2 * (2 * pi / 2600) / 3;  % variance
    end
    properties (SetAccess = private, Hidden = false)
        RightEnc = []; % right encoder values
        LeftEnc = [];  % left encoder values
        % Quantization effect
        noisyLeftEnc = [];  % right encoder measure
        noisyRightEnc = []; % left encoder measure
        % EKF quantities
        EKF_q_est;      % position estimation
        EKF_P;
        EKF_Q;
        EKF_q_store;    % position data stored
    end
    % definition laser sensor
    properties (Constant)
        laserAngularResolution = 0.36;  % [deg] laser sensor parameters
        lasermaxdistance = 4; % [m] laser sensor parameters Max FOV
        lasermindistance = 0; % [m] laser sensor parameters min FOV
        % noise
        laser_rho_sigma     = 0.02;             % variance
        laser_theta_sigma   = 0.1 * (pi / 180); % variance
    end
    properties (SetAccess = private, Hidden = false)
        laserScan_xy = cell.empty;   % contains scans at a certain location
        laserScan_2_xy = cell.empty; % contains scans at a certain location
        mindistance = 4; % min distance to start move [m]
        laserTheta = []; % theta's angle sector [rad]
        occgridglobal; % store occupacy grid
    end
    
    methods
        % class constructor
        function this = Robot(inputID, time, sampletime, initialposition, Map, ris)
            %ROBOT default constuctor to init a robot class.
            %to start a new a new robot it is necessary to provide an
            %identifier, the environment, and the resolution of the
            %occupacy grid.
            %
            %@param[in] inputID - identification number for robot
            %@param[in] time - length of total simulation
            %@param[in] sampletime - sampling time
            %@param[in] initialposition - start point, 3 coordinate
            %(x,y,orientation)
            %@param[in] Map - set the dimension of occupacy grid
            %@param[in] ris - set resolution of occupacygrid
            
            % check input constructor for passed arguments
            validateattributes(inputID,{'double'},{'nonnegative'})
            validateattributes(time,{'double'},{'nonnegative'})
            validateattributes(sampletime,{'double'},{'nonnegative'})
            validateattributes(initialposition,{'double'},{'ncols', 3})
            % initialize identification number of robot
            this.ID = inputID;
            fprintf('Initialize robot n: %3i\n', this.ID);
            % initialize simulation time and sample
            this.Dt = sampletime;     % Sampling time
            dimension = length(0:sampletime:time) - 1;  % Length of simulation
            this.laserScan_xy{1,dimension} = [];
            this.laserScan_2_xy{1,dimension} = [];
            % set initial position
            this.q = initialposition;
            this.q(1,3) = wrapToPi(this.q(1,3));  % wraps angles in lambda, in radians, to the interval [-pi pi].
            this.t = 0;
            this.steerangle = 0;
            % initialize Extend Kalman Filter aka EKF
            this.RightEnc = zeros(1,dimension); % right encoder values
            this.LeftEnc = zeros(1,dimension); % left encoder values
            this.noisyLeftEnc = zeros(1,dimension);  % right encoder measure
            this.noisyRightEnc = zeros(1,dimension); % left encoder measure
            this.EKF_q_est = zeros(3,1);
            this.EKF_P = eps * eye(3);
            this.EKF_Q = diag([this.enc_sigma^2, this.enc_sigma^2]);
            this.EKF_q_store = zeros(3, dimension);
            % initialize sector of angle laser theta
            this.laserTheta = pi/180*(-90:this.laserAngularResolution:90);
            %initialize occupacygrid
            room_length = max(Map.points(1,:));
            room_width  = max(Map.points(1,:));
            lgth =  floor(room_length / ris);
            wdth =  floor(room_width / ris);
            this.occgridglobal =zeros(lgth,wdth);
        end % definition constructor
        % function to compute the kinematics simulation
        this = UnicycleKinematicMatlab(this, it);
        this = setpointtarget(this, point);
        % function to compute Extend Kalman Filter
        this = ekfslam(this, it)
        % plot function
        [body, label, rf_x, rf_y, rf_z] = makerobot(this, t);
        [body, label, rf_x, rf_y, rf_z] = animate(this, it);
        % method to comupte laser scansion of the environment
        this = scanenvironment(this, ppoints, plines, it);
        [laserScan_xy] = getlaserscan(this, it);
        % setter & getter method for occupacy grid
        this = setOccupacygridglobal(this, occgrid)
        occupacygrid = getOccupacygridglobal(this);
    end
    methods (Access = private)
        % function to compute the kinematics simulation
        dy = UnicycleModel(this, t, y, piterator)
        this = EncoderSim(this, Vehicle); % Encoder Simulation
    end
    methods (Static)
        [v, omega] = UnicycleInputs(t, pdistance, ptheta) % Kinematic simulation
        [R] = rotationMatrix(theta) % compute rotation matrix in plane 2D
    end
end % definition class
