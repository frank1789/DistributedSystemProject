classdef Robot < handle
    %ROBOTMODEL Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        ID;
        % Dimension plot
        len = 5;
        hor = 10;
        %         y =[0;0;0]
        % quantiz
        q_d;
        t_d;
        t = [];
        q = [];
        u= [];
        % Encoder values
        RightEnc;
        LeftEnc;
        % Quantization effect
        quatizeffect_LeftEnc;
        quatizeffect_RightEnc;
        
        % EKF
        
        
        
    end
    
    properties (Constant)
        % Vehicle property
        whellradius = 0.15; % dimension of whell [m]
        interaxle = 0.56;   % dimension of interaxe[m] |---|
        
        % Encoder quantization
        enc_quantization = 2 * pi / 2600;
        % encoder noise
        enc_mu = 0;                   % mean
        enc_sigma = 2 * (2 * pi / 2600) / 3;  % variance
    end
    
    methods
        % class constructor
        function this = Robot(inputID)
            this.ID = inputID;
            fprintf('Initialize robot n: %i\n', this.ID);
        end
        
        % Kinematic simulation
        this = UnicycleKinematicMatlab(this, MdlInit, Vehicle)
        dy = UnicycleModel(this, t,y)
        makerobot(this)
        
        % Encoder Simulation
        this = EncoderSim(this, Vehicle)
        this = EncoderNoise(this)
    end
    
    methods (Static)
        % Kinematic simulation
        [v, omega] = UnicycleInputs(t)
    end
end
