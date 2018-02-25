function [  ] = Utilities_Manage(robot,ss,ris,Cost_map,ii)
%UTILITIES_MANAGE Summary of this function goes here
%   Detailed explanation goes here

            U  = -20000;
            idx = 0;
            beta = 1;
            target =zeros(3,length(robot));
            
           front = limitfov(robot{ss}, ris, ii);
           target(:,ss) = Reset_Target(robot{ss},ris,Cost_map(:,:,ss),ii);       

                for i=1:1:length(front(1,:))
                    %front >0 to avoid essor caused by transformation out from the map
                    if(isnan(robot{ss}.laserScan_2_xy{1,ii}(1,i)) && front(1,i)>0 && front(2,i)>0) 
                        target(:,ss)=[front(:,i) ;robot{ss}.q(ii,3)];
                        [ P ] = Utilities_Function( target,ss,length(robot),robot{ss}.mindistance);  % 3 number of robot %4 max range

                           PP=0;
                                for mm=1:1:length(robot) %number of robot
                                        if(mm~=ss)
                                        PP = PP + beta*norm(robot{mm}.target(1:2)-robot{mm}.q(ii,1:2));
                                        end
                                end
                                P = P-PP;
                                if(U<P)
                                    U=P;
                                    idx = i;
                                end
                    end
                end
                if(idx ~=0)
                    robot{ss}.setpointtarget([front(1,idx) front(2,idx) 0]);
                end
end