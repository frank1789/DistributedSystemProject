function [occparamters] = comunicate(obj, it,rr,occparamters)
%COMMUNICATE

MAX = 6; % 6[m] maximum distance of comunication
c = combnk(obj,2); % explore all combination groped in 2 colunm
for n = 1:length(c)
    [dist] = euclideandistance(c{n,1}.q(it,:),c{n,2}.q(it,:));
    if (dist < MAX)
        fprintf("one or more robots are in the communication area\n");
        fprintf("establish link\t robot: %i <---> robot: %i\n",c{n,1}.ID,c{n,2}.ID);
        %exchange laserscan and odometry
        Utilities_Manage(obj,rr,occparamters{rr}.ris,occparamters{rr}.Cost_map,it);
        occparamters{c{n,1}.ID}.comunication =1;
        occparamters{c{n,2}.ID}.comunication =1;
    end % if
end % for
clear c dist % free memory
end % function