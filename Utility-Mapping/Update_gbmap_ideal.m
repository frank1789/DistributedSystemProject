function [tempglobalmap]= Update_gbmap_ideal(Robot, ii, occparameters)
%UPDATE_GBMAP Summary of this function goes here
%   Detailed explanation goes here

ris     = occparameters.ris;
wdt     = occparameters.wdth;
lgth    = occparameters.lgth;

% initialize local variable
tempglobalmap = occparameters.Global_map; 
out = Robot.laserScan_2_xy{ii}(:,all(~isnan(Robot.laserScan_2_xy{ii}))); 
occ_mat = Occ_Grid(occparameters, out);

for i = 1:1:length(occ_mat(:,1))
    for j = 1:1:length(occ_mat(1,:))
       % if(occ_mat(i,j)~=0)
            A     = [cos(Robot.q(ii,3)), -sin(Robot.q(ii,3)), Robot.q(ii,1)/ris;
                     sin(Robot.q(ii,3)),  cos(Robot.q(ii,3)), Robot.q(ii,2)/ris;
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
            if tempglobalmap(wdt-CC(1),CC(2))==0
                tempglobalmap(wdt-CC(1),CC(2))= occ_mat(i,j);
                %Global(wdt-CC(1),CC(2))= occ_mat(i,j);
            else
                %saturation condition
                if ((occ_mat(i,j) + tempglobalmap(wdt-CC(1),CC(2)))/2 < occparameters.Min_Occ )
                tempglobalmap(wdt-CC(1),CC(2)) = 0;
                else
                tempglobalmap(wdt-CC(1),CC(2))= (occ_mat(i,j) + tempglobalmap(wdt-CC(1),CC(2)))/2;
                %Global(wdt-CC(1),CC(2))= (occ_mat(i,j) + Global(wdt-CC(1),CC(2)))/2;
                end
            end % if
   %     end %if
    end % end for-cycle j
end % for-cycle i
 % save the temp data
end % function