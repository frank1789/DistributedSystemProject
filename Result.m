%Weigth factor for each parameter
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

