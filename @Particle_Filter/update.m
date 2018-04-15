function [xEst, x_st] = update(this, Robot, it)
            %initial graphics
            figure(101)
            plot(this.Map(1,:),this.Map(2,:),'g*');hold on;
%             pMap.plotMap(); hold off
            
            figure(1); hold on; grid off ; axis equal;
            plot(this.Map(1,:),this.Map(2,:),'g*');hold on;
            
            set(gcf,'doublebuffer' , 'on');
            hObsLine = line ([0,0],[0,0]);
            set(hObsLine,'linestyle',':');
%             pMap.plotMap();
            hPoints = plot(this.xP(1,:),this.xP(2,:), ' .' );
            
            
            %do world iteration and get also the new xTrue
            this.SimulateWorld(Robot, it);
            
            %all particles are equally important
            L = ones(this.nParticles, 1) / this.nParticles;
            
            %figure out control
            xOdomNow = Robot.getOdometry(it); %GetOdometry(k,Robot,it);
            u = this.tcomp(this.tinv(this.xOdomLast),xOdomNow);
            this.xOdomLast = xOdomNow;
            
            %% do prediction
            %for each particle we add in control vector AND noise
            %the control noise adds diversity within the generation
            for p = 1:this.nParticles
                this.xP(:,p) = this.tcomp(this.xP(:,p),u+sqrt(this.UEst)*randn(3,1));
            end
            this.xP(3,:) = this.AngleWrapping(this.xP(3,:));
            
            %% observe a randomn feature
            [z,iFeature] = this.GetObservation(it);
            if(~isempty(z))
                %predict observation
                for p = 1:this.nParticles 
                    %what do we expect observation to be for this particle ?
                    zPred = this.DoObservationModel(this.xP(:,p), iFeature);
                    %on GetObs -> z = DoObservationModel(xTrue, iFeature,Map)+sqrt(RTrue)*randn(2,1);
                    %
                    %how different
                    Innov = z-zPred;
                    %get likelihood (new importance). Assume gaussian here but any pdf works!
                    %if predicted obs is very different from actual obs this score will be low
                    %->this particle is not very good at representing state . A lower score means
                    %it is less likely to be selected for the next generation ...
                    L(p) = exp(-0.5*Innov'*inv(this.REst)*Innov)+0.001;
                end
            end
            
            %% reselect based on weights:
            %particles with big weights will occupy a greater percentage of the
            %y axis in a cummulative plot
            CDF = cumsum(L)/sum(L);
            %so randomly (uniform) choosing y values is more likely to correspond to
            %more likely (better) particles ...
            iSelect = rand(this.nParticles,1);
            %find the particle that corresponds to each y value (just a look up)
            iNextGeneration = interp1(CDF,1:this.nParticles, iSelect, 'nearest', 'extrap');
            
            %copy selected particles for next generation ..
            this.xP = this.xP(:, iNextGeneration);
            %our estimate is simply the mean of teh particles
            this.xEst(it, :) = mean(this.xP,2);
            if(mod(it-2,10)==0)
                figure(1);
                set(hPoints,'XData',this.xP(1,:));
                set(hPoints,'YData',this.xP(2,:));
                
                if(~isempty(z))
                    set(hObsLine,'XData',[this.xEst(1),this.Map(1,iFeature)]);
                    set(hObsLine,'YData',[this.xEst(2),this.Map(2,iFeature)]);
                end
                
                figure(2);plot(this.xP(1,:),this.xP(2,:), ' .' );
                drawnow;
            end
            xEst = this.xEst; % return estimated
        end % update