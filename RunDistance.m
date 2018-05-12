function [tot_dist] = RunDistance(robot)


buffer = 0;
tot_dist = 0;
for ii=2:length(robot.q(:,1))
    
    buffer = norm(robot{1}.q(ii,1:2)-robot{1}.q(ii-1,1:2));
    tot_dist = part_dist + tot_dist;
end
end

