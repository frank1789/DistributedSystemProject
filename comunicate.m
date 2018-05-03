function [occparameters] = comunicate(obj, it,rr,occparameters)
%COMMUNICATE

MAX = occparameters{rr}.Max_com; % 6[m] maximum distance of comunication
c = combnk(obj,2); % explore all combination groped in 2 colunm
if length(obj)>2
for n = 1:length(c)
    [dist] = euclideandistance(c{n,1}.q(it,:),c{n,2}.q(it,:));
    if (dist < MAX && occparameters{c{n,1}.ID}.comunication ==0 && occparameters{c{n,2}.ID}.comunication ==0)
        fprintf("one or more robots are in the communication area\n");
        fprintf("establish link\t robot: %i <---> robot: %i\n",c{n,1}.ID,c{n,2}.ID);
        %exchange laserscan and odometry
        Utilities_Manage(obj,rr,occparameters,it);
        occparameters{c{n,1}.ID}.comunication =1;
        occparameters{c{n,2}.ID}.comunication =1;

        occparameters{c{n,1}.ID}.Cost_map = (occparameters{c{n,1}.ID}.Cost_map + occparameters{c{n,2}.ID}.Cost_map)/2;
        occparameters{c{n,2}.ID}.Cost_map = (occparameters{c{n,1}.ID}.Cost_map + occparameters{c{n,2}.ID}.Cost_map)/2;
    end % if
end % for
clear c dist % free memory

else
    [dist] = euclideandistance(c{1,1}.q(it,:),c{1,2}.q(it,:));
    if (dist < MAX && occparameters{c{1,1}.ID}.comunication ==0 && occparameters{c{1,2}.ID}.comunication ==0)
        fprintf("one or more robots are in the communication area\n");
        fprintf("establish link\t robot: %i <---> robot: %i\n",c{1,1}.ID,c{1,2}.ID);
        %exchange laserscan and odometry
        Utilities_Manage(obj,rr,occparameters,it);
        occparameters{c{1,1}.ID}.comunication =1;
        occparameters{c{1,2}.ID}.comunication =1;

        occparameters{c{1,1}.ID}.Cost_map = (occparameters{c{1,1}.ID}.Cost_map + occparameters{c{1,2}.ID}.Cost_map)/2;
        occparameters{c{1,2}.ID}.Cost_map = (occparameters{c{1,1}.ID}.Cost_map + occparameters{c{1,2}.ID}.Cost_map)/2;
    end
end
end % function