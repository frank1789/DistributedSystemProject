addpath('Utility-Mapping')
%Weigth factor for each parameter
clear all
clc
close all
alpha = 3; % weight factor for the number of robot used this consider the cost of buy a new robot for the application
beta  = 4; % weight factor for the distance travelled used this take in consideration power consumption cost
gamma = 5; % weight factor for the time needed this consider how is important have quick result from the system
tilde = 6; % weight factor for the exploration of the map this consider how accuracy is important in our simulation
j = 0;
% preallocating
Total_Cost = [];
result = cell.empty;
listFile = what;

for i = 1:length(listFile.mat)
    result{i} = load(listFile.mat{i});
    result{i}.Simulation_Time
    length(result{i}.datatoexport)
end

time_needed = 0;
%% Primo tipo di analisi
for i = 1:length(listFile.mat)
   % result{i} = load(listFile.mat{i});
    % Time needed
    if (length(result{i}.datatoexport{1}.q)) * 0.05 > time_needed
        j = j + 1;
    else
        j = 1;
    end
    time_needed = result{i}.Simulation_Time;
    numrobot = length(result{i}.datatoexport);  % Number of robot used

    % Map explored factor
    C = resizem(result{i}.datatoexport{1}.costmap, [60 60],'bicubic');
    explored_map = (length(find(C > 0.6))) / length(result{i}.map.available) * 100;

    Map_robot(numrobot,j) = explored_map;
end

figure(10)
hold on 

title('Explored Map as function of # robot & Time needed')
ylabel('% Exlpored Map')        % x-axis label
xlabel('Time needed[s]')   % y-axis label
plot([200,400,600,800,1000,1200,1400,1600,1800],Map_robot(1,:),'b')
plot([200,400,600,800,1000,1200,1400,1600,1800],Map_robot(2,:),'r')
plot([200,400,600,800,1000,1200,1400,1600,1800],Map_robot(3,:),'g')
plot([200,400,600,800,1000,1200,1400,1600,1800],Map_robot(4,:),'k')
plot([200,400,600,800,1000,1200,1400,1600,1800],Map_robot(5,:),'m')
legend('n° robot 1','n° robot 2','n° robot 3','n° robot 4','n° robot 5')
%plot([600 800 1000 1200 1400],Map_robot(4,:),'y')

%print('Report/imgs/ExploredMap','-depsc','-r0')
print('ExploredMap','-depsc','-r0')
%% Terzo tipo di analisi

fit = goodnessOfFit(result{1}.pf{1}.xEst(:,1:2),result{1}.robot{1}.q(1:end-1,1:2),'NRMSE');


%% Secondo tipo di analisi 
for i = 1:length(listFile.mat)
   % result{i} = load(listFile.mat{i});
    time_needed = result{i}.Simulation_Time; % Time needed
    if (length(result{i}.robot{1}.q)) * 0.05 > time_needed
        j = j + 1;
    else
        j = 1;
    end
    numrobot = length(result{i}.robot);  % Number of robot used
    % Total ammount of meter that each robor has done
    buffer = 0;
    tot_dist = 0;
    for indexrobot = 1:numrobot
        buffer = RunDistance(result{i}.robot{indexrobot});
        tot_dist = buffer + tot_dist;
    end
    % Map explored factor
    C = resizem(result{i}.occparameters{1}.Cost_map, [40 40],'bicubic');
    explored_map = (length(find(C > 1.75))) / length(result{i}.map.available) * 100;
    Total_Cost(numrobot,j)= alpha * numrobot + beta * tot_dist + ...
        gamma * time_needed + tilde * explored_map;
end
[opt_robot, opt_time] = minmat(Total_Cost);
min_value = Total_Cost(opt_robot, opt_time);
figure()
surf(Total_Cost)
title('Graph of the Total Cost function of # robot & Time needed')
xlabel('# of robot')        % x-axis label
ylabel('Time needed[it]')   % y-axis label
zlabel('Total_cost')        % y-axis label

