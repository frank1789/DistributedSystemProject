function printresult(Robot, Simulation_Time, Map, occparameters, attempt_number)
%Weigth factor for each parameter
alpha = 3; % weight factor for the number of robot used this consider the cost of buy a new robot for the application
beta  = 4; % weight factor for the distance travelled used this take in consideration power consumption cost
gamma = 5; % weight factor for the time needed this consider how is important have quick result from the system
tilde = 6; % weight factor for the exploration of the map this consider how accuracy is important in our simulation
j = 1;
% preallocating
Total_Cost = [];
time_needed = Simulation_Time;
% Total ammount of meter that each robor has done
buffer = 0;
tot_dist = 0;
for indexrobot = 1:length(Robot)
    buffer = RunDistance(Robot{indexrobot});
    tot_dist = buffer + tot_dist;
end
% Map explored factor
for idx = 1:length(occparameters)
    C = resizem(occparameters{idx}.Cost_map, [40 40],'bicubic');
    explored_map = (length(find(C > 1.75))) / length(Map.available) * 100;
    Total_Cost(length(Robot),j)= alpha * length(Robot) + beta * tot_dist + ...
        gamma * time_needed + tilde * explored_map;
end

tc = strtrim(sprintf('%5.5f     ',Total_Cost));
fileID = fopen('Report/result.txt','a');
fprintf(fileID,'%7i\t %10i\t %7i\t %5.5f\t %10i\t %s\n', attempt_number, length(Robot), Simulation_Time, tot_dist, Map.width, tc);
fclose(fileID);
