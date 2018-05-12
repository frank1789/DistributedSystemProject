result = cell.empty;
listFile = what;
for i = 1:length(listFile.mat) 
   result{i} = load(listFile.mat{i});
end
% load('n_robot_1_Sim_time_1200_attempt_num_1.mat')
% load('n_robot_1_Sim_time_1200_attempt_num_2.mat')
% load('n_robot_1_Sim_time_1200_attempt_num_3.mat')
% 
% load('n_robot_1_Sim_time_1500_attempt_num_1.mat')
% load('n_robot_1_Sim_time_1500_attempt_num_2.mat')
% load('n_robot_1_Sim_time_1500_attempt_num_3.mat')
% 
% load('n_robot_2_Sim_time_1200_attempt_num_1.mat')
% load('n_robot_2_Sim_time_1200_attempt_num_2.mat')
% load('n_robot_2_Sim_time_1200_attempt_num_3.mat')
% 
% load('n_robot_2_Sim_time_1500_attempt_num_1.mat')
% load('n_robot_2_Sim_time_1500_attempt_num_2.mat')
% load('n_robot_2_Sim_time_1500_attempt_num_3.mat')
% 
% load('n_robot_3_Sim_time_1200_attempt_num_1.mat')
% load('n_robot_3_Sim_time_1200_attempt_num_2.mat')
% load('n_robot_3_Sim_time_1200_attempt_num_3.mat')
% 
% load('n_robot_3_Sim_time_1500_attempt_num_1.mat')
% load('n_robot_3_Sim_time_1500_attempt_num_2.mat')
% load('n_robot_3_Sim_time_1500_attempt_num_3.mat')
% 
% load('n_robot_4_Sim_time_1200_attempt_num_1.mat')
% load('n_robot_4_Sim_time_1200_attempt_num_2.mat')
% load('n_robot_4_Sim_time_1200_attempt_num_3.mat')
% 
% load('n_robot_4_Sim_time_1500_attempt_num_1.mat')
% load('n_robot_4_Sim_time_1500_attempt_num_2.mat')
% load('n_robot_4_Sim_time_1500_attempt_num_3.mat')

%Weigth factor for each parameter

alpha = 3; % weight factor for the number of robot used this consider the cost of buy a new robot for the application 
beta  = 4; % weight factor for the distance travelled used this take in consideration power consumption cost
gamma = 5; % weight factor for the time needed this consider how is important have quick result from the system
tilde = 6; % weight factor for the exploration of the map this consider how accuracy is important in our simulation


%% Number of robot used
n_robt = length(robot);

%% Total ammount of meter that each robor has done

buffer = 0;
for i=1:length(robot)
buffer = RunDistance(robot{i});
tot_dist = buffer+tot_dist;
end

%% Time needed
time_needed = Simulation_time;

%% Map explored factor


%% Function to be minimize
n_robot = [1 2 3 4];
Simulation_time = [900 1200 1500];

for i = 1:length(robot)
    for j = 1:length(Simulation_time)
       Total_Cost(i,j)= alpha*n_robt(i) + beta*tot_dist + gamma*time_needed(j) + tilde*explored_map;
    end
end

[row,column] = minmat(Total_Cost);
opt_robot = n_robot(row);
opt_time  = Simulation_time(column);
min_value = Total_Cost(row,column);

figure()
surf(robot{1}.occgridglobal)
title('Graph of the Total Cost function of # robot & Time needed')
xlabel('# of robot')  % x-axis label
ylabel('Time needed[it]') % y-axis label
zlabel('Total_cost') % y-axis label
