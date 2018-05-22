function [occparameters] = comunicate(Robot, it, rr, occparameters)
%COMMUNICATE
%
% @param[in] Robot: class robot, contains robot information
% @param[in] it: iteration of the simulation
% @param[in] rr: robot index cell
% @param[in] occparameters: parameters of occupacy grid and utily

MAX = occparameters{rr}.Max_com; % 6[m] maximum distance of comunication
c = combnk(Robot, 2); % explore all combination groped in 2 colunm
switch length(Robot)
    case 0
        return
        
    case 1
        return
        
    case 2
        [dist] = euclideandistance(c{1,1}.q(it,:),c{1,2}.q(it,:));
        if (dist < MAX && (occparameters{c{1,1}.ID}.comunication ==0 || occparameters{c{1,2}.ID}.comunication ==0))
            fprintf("one or more robots are in the communication area\n");
            fprintf("establish link\t robot: %i <---> robot: %i\n",c{1,1}.ID,c{1,2}.ID);
            Utilities_Manage(Robot,rr,occparameters,it);
            occparameters{c{1,1}.ID}.comunication = 1;
            occparameters{c{1,2}.ID}.comunication = 1;
            occparameters{c{1,1}.ID}.Cost_map(occparameters{c{1,2}.ID}.Cost_map == 2) = 2;
            occparameters{c{1,2}.ID}.Cost_map(occparameters{c{1,1}.ID}.Cost_map == 2) = 2;
        end
        
    otherwise
        for n = 1:length(c)
            [dist] = euclideandistance(c{n,1}.q(it,:),c{n,2}.q(it,:));
            if (dist < MAX && (occparameters{c{n,1}.ID}.comunication ==0 || occparameters{c{n,2}.ID}.comunication ==0))
                fprintf("one or more robots are in the communication area\n");
                fprintf("establish link\t robot: %i <---> robot: %i\n",c{n,1}.ID,c{n,2}.ID);
                Utilities_Manage(Robot,rr,occparameters,it);
                occparameters{c{n,1}.ID}.comunication = 1;
                occparameters{c{n,2}.ID}.comunication = 1;
                occparameters{c{n,1}.ID}.Cost_map(occparameters{c{n,2}.ID}.Cost_map == 2) = 2;
                occparameters{c{n,2}.ID}.Cost_map(occparameters{c{n,1}.ID}.Cost_map == 2) = 2;
            end % if
        end % for
end
clear c dist % free memory
end % function