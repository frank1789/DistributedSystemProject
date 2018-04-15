classdef Particle_Filter < handle
    
    properties
        nParticles;
        xTrue;
        Map;
        RTrue;
        UTrue;
        UEst;
        REst;
        nSteps;
        LastOdom;
        xOdomLast;
        xP;
    end
    
    
    %change this to see how sensitive we are to the number of particle
    %(hypotheses run) especially in relation to initial distribution !
    %nParticles = 400;
    %Map = max(pMap.points(1,:))*rand(2,30);% - (max(pMap.point(1,:))/2);  %landmark position
    methods
        function this = Particle_Filter(Robot, it)
            this.nParticles = 1000;
            this.UTrue = diag([0.01,0.01,1*pi/180]).^2;
            this.RTrue = diag([2.0,3*pi/180]).^2;
            this.UEst = 1.0 * this.UTrue;
            this.REst = 1.0 * this.RTrue;
            this.xTrue = Robot.q(it,:)';
            
            this.xOdomLast = this.GetOdometry(Robot, it);
            this.nSteps = 2000;
            %initial conditions: - a point cloud around truth
            this.xP = repmat(this.xTrue,1,this.nParticles) ...
                + diag([8,8,0.4]) * randn(3,this.nParticles);
            %%%%%%%%% storage %%%%%%%%
        end
        angle = AngleWrapping(this, angle)
        [z] = DoObservationModel(xVeh, iFeature,Map)
        [z,iFeature] = GetObservation(k)
        [xEst,x_st,x_od] = update(this, k)
        [xnow] =  GetOdometry(this, Robot, it)
         u = GetRobotControl(this, Robot,it)
        this = SimulateWorld(k,Robot,it)
        tac = tcomp(this, tab, tbc)
        tba=tinv(tab)
        tba=tinv1(tab)
    end
end
