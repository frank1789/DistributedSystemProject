function [ P ] = Utilities_Function(robot, idx_robot, max_range)
%UTILIES_FUNCTION  calculates the utility value for the given robot target
% and location respect the target and location of the other ones.
%The formula is taken from the article "Coordinated Multi-Robot
%Exploration".

P=0;
for i=1:length(robot)
    if(idx_robot~=i)
        d = norm(robot{idx_robot}.target(1:2) - robot{i}.target(1:2));
        if(d<max_range)
            Pd = 1 - d/max_range;
        else
            Pd = 0;
        end
        P = P + Pd;
    end
end
end
