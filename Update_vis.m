function [ Cost_map ] = Update_vis( Cost_map,robot,ii,wdt,lgth,occ_mat,ris );
%UPDATE_VIS Summary of this function goes here
%   Detailed explanation goes here
    for i = 1:1:length(occ_mat(:,1))
        for j = 1:1:length(occ_mat(1,:))
                 A     = [cos(robot.q(ii,3)), -sin(robot.q(ii,3)), robot.q(ii,1)/ris; 
                          sin(robot.q(ii,3)),  cos(robot.q(ii,3)), robot.q(ii,2)/ris;  
                            0                 0             1]*[i ;(length(occ_mat(1,:)))/2+1-j; 1]; 
                    A=floor(A);
                            if(A(2)>wdt || A(2)==wdt)
                            A(2) = wdt-1; 
                            end
                            if(A(2)==0 || A(2)<0)
                                A(2)=1;
                                end
                            if(A(1)==0 || A(1)<0)
                                A(1)=1;
                            end
                            if(A(1)>lgth)
                            A(1) = lgth; 
                            end
                    CC=[A(2),A(1)];
                    Cost_map(wdt-CC(1),CC(2))= 5;
            end
        end
end

