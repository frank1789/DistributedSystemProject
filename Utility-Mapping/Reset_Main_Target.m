function [itneeded,target] = Reset_Main_Target(robot,ii,occparameters)

%Tasks of this funciton is to o
ris      = occparameters.ris;
Cost_map = occparameters.Cost_map;

[raw,column] = find(Cost_map==0.5);
rand_idx = randsample(raw,1);
idx0 = find(raw==rand_idx);
idx = randsample(idx0,1);
rand_raw = raw(idx);
rand_column    = column(idx);

lgth = ceil(max(size(Cost_map))*ris);

robot.setpointtarget([ceil(rand_column*ris),ceil(lgth-rand_raw*ris),robot.q(ii,3)]);
target = [ceil(rand_column*ris),ceil(lgth-rand_raw*ris),robot.q(ii,3)];


%robots go to 0.5 m/s so to reach a distance of 3m it need 6s and 6/0.05 it
%where 0.05 is the sampling time
itneeded = 2*(norm(robot.q(ii,1:2) - target(1:2)))/0.05;
 
end

