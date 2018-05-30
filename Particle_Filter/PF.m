function [xEst,x_st,x_od] = PF(Robot,it,pMap,nParticles)
%PF Summary of this function goes here
%   Detailed explanation goes here


global xTrue;
global Map;
global RTrue;
global UTrue;
global nSteps;
global LastOdom;

nSteps = 8000;

%change this to see how sensitive we are to the number of particle
%(hypotheses run) especially in relation to initial distribution !
%nParticles = 400;
Map = max(pMap.points(1,:))*rand(2,30);% - (max(pMap.point(1,:))/2);  %landmark position

UTrue = diag([0.01,0.01,1*pi/180]).^2;

RTrue = diag([0.7071,3*pi/180]).^2;

UEst = 1.0*UTrue;

REst = 1.0*RTrue;

xTrue = Robot.q(it,:)';

xOdomLast = Robot.q(it,:)';
x_st(it,1:3)= Robot.q(it,:)';

%initial conditions: - a point cloud around truth
xP =repmat(xTrue,1,nParticles)+diag([8,8,0.4])*randn(3,nParticles);
%%%%%%%%% storage %%%%%%%%

%initial graphics
figure(101)
plot(Map(1,:),Map(2,:),'g*');hold on;
pMap.plotMap(); hold off

figure(1); hold on; grid off ; axis equal;
plot(Map(1,:),Map(2,:),'g*');hold on;

set(gcf,'doublebuffer' , 'on');
hObsLine = line ([0,0],[0,0]);
set(hObsLine,'linestyle',':');
pMap.plotMap();
hPoints = plot(xP(1,:),xP(2,:), ' .' );
k=1;

for it = 2:nSteps
    %do world iteration and get also the new xTrue
    SimulateWorld(k,Robot,it);

    %all particles are equally important
    L = ones(nParticles,1)/nParticles;
    
    %figure out control
    xOdomNow = Robot.EKF_q_store(:,it); %GetOdometry(k,Robot,it);
    u = tcomp(tinv(xOdomLast),xOdomNow);
    xOdomLast = xOdomNow;
    
    %% do prediction
    %for each particle we add in control vector AND noise
    %the control noise adds diversity within the generation
            for p = 1:nParticles
            xP(:,p) = tcomp(xP(:,p),u+sqrt(UEst)*randn(3,1));
            end
    xP(3,:) = AngleWrapping(xP(3,:));
    
    %% observe a randomn feature
    [z,iFeature] = GetObservation(it);
            if(~isempty(z))
            %predict observation
                for(p = 1:nParticles)
                %what do we expect observation to be for this particle ?
                zPred = DoObservationModel(xP(:,p),iFeature,Map);
                %on GetObs -> z = DoObservationModel(xTrue, iFeature,Map)+sqrt(RTrue)*randn(2,1);
                %
                %how different
                Innov = z-zPred;
                %get likelihood (new importance). Assume gaussian here but any pdf works!
                %if predicted obs is very different from actual obs this score will be low
                %->this particle is not very good at representing state . A lower score means
                %it is less likely to be selected for the next generation ...
                L(p) = exp(-0.5*Innov'*inv(REst)*Innov)+0.001;
                end;
            end;
            
    %% reselect based on weights:
    %particles with big weights will occupy a greater percentage of the
    %y axis in a cummulative plot
    CDF = cumsum(L)/sum(L);
    %so randomly (uniform) choosing y values is more likely to correspond to
    %more likely (better) particles ...
    iSelect = rand(nParticles,1);
    %find the particle that corresponds to each y value (just a look up)
    iNextGeneration = interp1(CDF,1:nParticles,iSelect,'nearest','extrap');
    
    %copy selected particles for next generation ..
    xP = xP(:,iNextGeneration);
    %our estimate is simply the mean of teh particles
    xEst = mean(xP,2);
%             if(mod(it-2,10)==0)
%             figure(1);
%             set(hPoints,'XData',xP(1,:));
%             set(hPoints,'YData',xP(2,:));
%             
%                 if(~isempty(z))
%                 set(hObsLine,'XData',[xEst(1),Map(1,iFeature)]);
%                 set(hObsLine,'YData',[xEst(2),Map(2,iFeature)]);
%                 end;
%             
%             figure(2);plot(xP(1,:),xP(2,:), ' .' );
%             drawnow;
%             end;
x_st(it,1:3)= xEst;
%x_od(it,1:3)= xOdomLast;
end;

end % function