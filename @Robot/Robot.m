classdef Robot < handle
    %ROBOTMODEL Summary of this class goes here
    %   Detailed explanation goes here

    properties
        ID;
        % Dimension plot
        len = 5;
        hor = 10;
        y =[0;0;0]
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
        % constructor
        function this = Robot(inputID)
            this.ID = inputID;
            message = sprintf('Initialize robot n: %i', this.ID);
            disp(message);
        end

        function this = UnicycleKinematicMatlab(this, MdlInit, Vehicle)

            % Simulation set-up
            Dt = MdlInit.Ts;
            this.t = 0:Dt:MdlInit.T;

            % Unicycle dynamic
            [this.t, this.q] = ode45(@(t,y) this.UnicycleModel(t,y), this.t, Vehicle.q0);

            % Input sequence
            [v, omega] = this.UnicycleInputs(this.t);
            this.u = [v'; omega'];
        end


        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %% Additional functions


        function dy = UnicycleModel(this, t,y)

            % Input parser
            xu = y(1);
            yu = y(2);
            thetau = y(3);

            [v, omega] = this.UnicycleInputs(t);

            % System kinematic
            xu_d = cos(thetau)*v;
            yu_d = sin(thetau)*v;
            thetau_d = omega;

            % Output
            dy = [xu_d; yu_d; thetau_d];
        end

                % plot
        function makerobot(this)
            hold on
            rectangle('Position',[0 0 2 4],'Curvature',0.2)
            % rectangle('Position',[6 0 2 4],'Curvature',1)
            text(1.1,2.1,sprintf('ID: %i',this.ID))

            quiver(1, 2, 0, 1, 'r')
            quiver(1,2,1,0,'g')
            quiver3(1,2,0,0,0,1,'b')
            axis equal
            hold off
        end

        function this = EncoderSim(this, Vehicle)

          % Motors angular velocities
          OmegaR = (2*this.u(1,:) + this.interaxle*this.u(2,:))/(2*this.whellradius);
          OmegaL = (2*this.u(1,:) - this.interaxle*this.u(2,:))/(2*this.whellradius);

          % Angular increments for 'Delta t'
          Right_Enc = [0, OmegaR(1:end-1).*diff(this.t')];
          Left_Enc =  [0, OmegaL(1:end-1).*diff(this.t')];

          % Encoder values
          this.RightEnc = cumsum(Right_Enc);
          this.LeftEnc  = cumsum(Left_Enc);
          this.EncoderNoise();
        end

        function this = EncoderNoise(this)

          % Measurement noise %
          RightEnc = this.RightEnc + randn(1,length(this.RightEnc)) * this.enc_sigma + this.enc_mu;
          LeftEnc  = this.LeftEnc + randn(1,length(this.LeftEnc)) * this.enc_sigma + this.enc_mu;

          % Quantization effect
          this.quatizeffect_RightEnc = round(this.RightEnc/this.enc_quantization) * this.enc_quantization;
          this.quatizeffect_LeftEnc  = round(this.LeftEnc/this.enc_quantization) * this.enc_quantization;
        end





    end

      methods (Static)
        function [v, omega] = UnicycleInputs(t)

            v = 1*ones(length(t),1);    % m/s
            omega = 2*sin(2*pi*t/10).*cos(2*pi*t/2); % rad/s
        end












    end


























end
