addpath('Utility-Mapping')
%Weigth factor for each parameter
clear all
clc
close all

% preallocating
Map_robot  = [];
Total_Dist = [];

result = cell.empty;
listFile = what;

for i = 1:length(listFile.mat)
    result{i} = load(listFile.mat{i});
    result{i}.Simulation_Time
    length(result{i}.datatoexport)
end

%% 1° Result Explored Map

time_needed = 0;
j = 0;
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
    C = resizem(result{i}.datatoexport{1}.costmap, [40 40],'bicubic');
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
legend('n° robot 1','n° robot 2','n° robot 3','n° robot 4','n° robot 5')

print('ExploredMap','-depsc','-r0')



%% 2° Result Global Map given by the best exploration simulation

sim_numb = 27;

Global_Map_Real  = (result{sim_numb}.datatoexport{1}.occgridglobal+result{sim_numb}.datatoexport{2}.occgridglobal+result{sim_numb}.datatoexport{3}.occgridglobal)/3;
Global_Map_Ideal = (result{sim_numb}.datatoexport{1}.Globalmap+result{sim_numb}.datatoexport{2}.Globalmap+result{sim_numb}.datatoexport{3}.Globalmap)/3;

figure(11)
title('Ideal Explored Map for the 3 robot configuration and 1800 second')
mesh(Global_Map_Ideal)
colormap(gray)
print('IdealMap','-depsc','-r0')

figure(12)
title('Real Explored Map for the 3 robot configuration and 1800 second')
mesh(Global_Map_Real)
colormap(gray)
print('RealMap','-depsc','-r0')
% 

%% 3° Result the total Distance travelled

time_needed = 0;
j=0;
for i = 1:length(listFile.mat)
   % result{i} = load(listFile.mat{i});
  %  time_needed = result{i}.Simulation_Time; % Time needed
    if (length(result{i}.datatoexport{1}.q)) * 0.05 > time_needed
        j = j + 1;
    else
        j = 1;
    end
    time_needed = result{i}.Simulation_Time;
    numrobot = length(result{i}.datatoexport);  % Number of robot used
    % Total ammount of meter that each robor has done
    buffer = 0;
    tot_dist = 0;
    for indexrobot = 1:numrobot
        buffer = RunDistance(result{i}.datatoexport{indexrobot});
        tot_dist = buffer + tot_dist;
    end
    % Map explored factor
    
    Total_Dist(numrobot,j)= tot_dist;
end
    
 
figure(13)
hold on 

title('Distance travelled as function of # robot & Time needed')
ylabel('Distance travelled in # robot[m]')        % x-axis label
xlabel('Time needed[s]')   % y-axis label
plot([200,400,600,800,1000,1200,1400,1600,1800],Total_Dist(1,:),'b')
plot([200,400,600,800,1000,1200,1400,1600,1800],Total_Dist(2,:),'r')
plot([200,400,600,800,1000,1200,1400,1600,1800],Total_Dist(3,:),'g')
plot([200,400,600,800,1000,1200,1400,1600,1800],Total_Dist(4,:),'k')
legend('n° robot 1','n° robot 2','n° robot 3','n° robot 4')

print('TotalDistance','-depsc','-r0')



%% 4° Result Particle filter consideration

sim_numb_2 = 27;

figure(14)
result{1}.map.plotMap
 hold on; axis equal;
for z = 1:length(result{sim_numb_2}.datatoexport)
    plot(result{sim_numb_2}.datatoexport{z}.q(:,1),result{sim_numb_2}.datatoexport{z}.q(:,2),'b')
    plot(result{sim_numb_2}.datatoexport{z}.pfxEst(:,1),result{sim_numb_2}.datatoexport{z}.pfxEst(:,2),'r')
end

print('ParticleFilter','-depsc','-r0')


fit = goodnessOfFit(result{sim_numb_2}.datatoexport{z}.pfxEst(:,1:2),result{sim_numb_2}.datatoexport{z}.q(1:end-1,1:2),'NRMSE');
