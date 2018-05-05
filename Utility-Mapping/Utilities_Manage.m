function [  ] = Utilities_Manage(robot,ss,occparameters,ii)
%UTILITIES_MANAGE is the implementation of utility function. Task of this
%function is to give an optimum target selection for each robot in order to
%explore the given map in a minimum ammount of time.
%The strategy used is the one given in the article Coordinated Multi-Robot Exploration

%Parmameter initialization
Cost_map = occparameters{ss}.Cost_map;
ris      = occparameters{ss}.ris;
beta = occparameters{ss}.beta_cost;

U  = -20000;   % initialization of the Utility value
idx = 0;       % initialization of target location index
% obtain the frontier for the given robot ss
front = limitfov(robot{ss}, ris, ii);
%Set the best target for each robot in a sequential way
for i = 1:1:length(front(1,:))
    %front >0 to avoid essor caused by transformation out from the map
    if(isnan(robot{ss}.laserScan_xy{1,ii}(1,i)) && front(1,i)>0 && front(2,i)>0)
        %     robot{ss}.setpointtarget([front(1,i) ,front(2,i) ,robot{ss}.q(ii,3)+0.0063*(251-i)]);
        robot{ss}.setpointtarget([front(1,i) ,front(2,i) , 0]);
        [ P ] = Utilities_Function(robot, ss, robot{ss}.mindistance);  % 3 number of robot %4 max range
        Ct = 0; %cost inizialization
        for j = 1:1:length(robot) %number of robot
            Ct = Ct + beta * norm(robot{j}.target(1:2)-robot{j}.q(ii-1,1:2));
        end
        P = P - Ct;
        if U < P
            U=P;
            idx = i;
        end
    end
end
if(idx ~=0)
    %robot{ss}.setpointtarget([front(1,idx), front(2,idx), robot{ss}.q(ii,3)+0.0063*(251-idx)]);
    robot{ss}.setpointtarget([front(1,idx), front(2,idx),0]);
else
    robot{ss}.setpointtarget(Reset_Target(robot{ss},ii, occparameters));
end
end