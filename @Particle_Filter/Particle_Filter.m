classdef Particle_Filter
    %PARTICLE_FILTER  methods are a set of genetic, Monte Carlo algorithms used
    %to solve filtering problems arising in signal processing and Bayesian
    %statistical inference.
    %
    % Particle_Filter Properties:
    %    nParticles - Number of particles sensitive we are to the number of
    %                 particle (hypotheses run) especially in relation to
    %                 initial distribution!
    %     xTrue - Real postion
    %     Map - Position of landamark & map
    %     RTrue - Real State
    %     UTrue - Estimated
    %     UEst - Estimated state
    %     REst - Estimated Error
    %     xOdomLast - Last position computed from odometry
    %     xP - Particle sample
    %     xEst - Position Estimeted
    %     qEst - Postion
    %
    % Particle_Filter Methods:
    %     Particle_Filter(Robot, pMap, it) - Constructor
    %     SimulateWorld(this, Robot, it) - update the world for particle
    %     AngleWrapping(this, angle) - support function
    %     DoObservationModel(this, xVeh, iFeature) - represent the observation model
    %     GetObservation(this, it, lentime) - return data from observation model
    %     GetOdometry(this, Robot, it) - get data odometry
    %     update(this, Robot, lentime, it) - compute the particlefilter online simultation
    %     GetRobotControl(this, Robot,it) - return velocity
    %     tcomp(this, tab, tbc) - support function
    %     tinv(this, tab) - support function
    %     tinv1(this, tab) - support function
    
    properties (SetAccess = 'private', Hidden = false)
        nParticles;
        xTrue;
        Map;
        RTrue;
        UTrue;
        UEst;
        REst;
        xOdomLast;
        xP;
        xEst;
        qEst;
    end
    
    methods
        function this = Particle_Filter(Robot, landmark, it)
            %PARTICLE_FILTER default construtctor initialize class properties
            %
            %@param[in] Robot - class Robot
            %@param[in] pMap - class Map
            %@param[in] it - index of time simulation
            
            this.UTrue = diag([0.01,0.01,1*pi/180]).^2;
            this.RTrue = diag([sqrt((1/3)^2+(1/3)^2),3*pi/180]).^2;
            this.nParticles = 400;
            this.UEst = 1.0 * this.UTrue;
            this.REst = 1.0 * this.RTrue;
            this.xTrue = Robot.q(it,:)';
            this.Map = landmark;
            this.xOdomLast =  Robot.q(it,:)';
            this.qEst = Robot.q(it,:)';
            this.xEst(1,:) = Robot.q(it,:)';
            %initial conditions: - a point cloud around truth
            this.xP = repmat(this.xTrue,1,this.nParticles) ...
                + diag([8,8,0.4]) * randn(3,this.nParticles);
        end
        angle = AngleWrapping(this, angle)
        z = DoObservationModel(this, xVeh, iFeature)
        [z, iFeature] = GetObservation(this, it, lentime)
        [this, odometry] = setOdometry(this, Robot, it)
        this = update(this, Robot, lentime, it)
        u = GetRobotControl(this, Robot,it)
        this = SimulateWorld(this, Robot, it)
        tac = tcomp(this, tab, tbc)
        tba = tinv(this, tab)
        tba = tinv1(this, tab)
    end
end
