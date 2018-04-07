function Update_gbmap(robot,ii,wdt,lgth,occ_mat,lid_mat)
%UPDATE_GBMAP Summary of this function goes here
%   Detailed explanation goes here

% initialize local variable
tempglobalmap = robot.getOccupacygridglobal();
 out = robot.laserScan_2_xy{ii}(:,all(~isnan(robot.laserScan_2_xy{ii})));
[ occ_mat(:,:)] = Occ_Grid( occ_mat(:,:),lid_mat(:,:),out);
for i = 1:1:length(occ_mat(:,1))
    for j = 1:1:length(occ_mat(1,:))
        if(occ_mat(i,j)~=0)
            A     = [cos(robot.q(ii,3)), -sin(robot.q(ii,3)), robot.q(ii,1)/0.015;
                sin(robot.q(ii,3)),  cos(robot.q(ii,3)), robot.q(ii,2)/0.015;
                0                 0             1]*[i ;267-j; 1];
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
            if tempglobalmap(wdt-CC(1),CC(2))==0
                tempglobalmap(wdt-CC(1),CC(2))= occ_mat(i,j);
            else
                tempglobalmap(wdt-CC(1),CC(2))= (occ_mat(i,j) + tempglobalmap(wdt-CC(1),CC(2)))/2;
            end % if
        end %if
    end % end for-cycle j
end % for-cycle i
% save the temp data
robot.setOccupacygridglobal(tempglobalmap);
clear tempglobalmap
end % function

