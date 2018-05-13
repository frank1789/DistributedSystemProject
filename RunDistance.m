function [tot_dist] = RunDistance(robot)
buffer = 0;
tot_dist = 0;
for ii=2:length(robot.q(:,1))
    
    buffer = norm(robot.q(ii,1:2)-robot.q(ii-1,1:2));
    tot_dist = buffer + tot_dist;
end
end