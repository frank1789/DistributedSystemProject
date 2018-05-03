function [ Cost_map ] = Update_vis(occparameters,robot,ii)
%UPDATE_VIS Summary of this function goes here
%   Detailed explanation goes here

wdt      = occparameters.wdth;
lgth     = occparameters.lgth;
ris      = occparameters.ris;
Cost_map = occparameters.Cost_map;

 out = robot.laserScan_2_xy{ii}(:,all(~isnan(robot.laserScan_2_xy{ii})));
[ occ_mat(:,:)] = Occ_Grid(occparameters,out);

muro = 0;
j0 = length(occ_mat(1,:))/2;
[row, column] = find(occ_mat<0);

for j = j0:1:length(occ_mat(1,:))
  if j > max(column)
    break
  end
    for i = 1:1:length(occ_mat(:,1))
        if(occ_mat(i,j)~=0 || norm([j-j0,0] + [0,i])> 4/ris )
            muro = 1;
            if(occ_mat(i,j)~=0)
       %     fprintf('STOPPPPPP')
            end
            break
        end
            if(~muro)
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
            if(A(1)>lgth|| A(1)==lgth)
                A(1) = lgth-1;
            end
           
            CC=[A(2),A(1)];
            Cost_map(wdt-CC(1),CC(2))= 2;
            
            end
    end
muro = 0;



end

muro=0;

for j = j0:-1:1
          
   if j < min(column)
    break
   end
    
    for i = 1:1:length(occ_mat(:,1))
        if(occ_mat(i,j)~=0 || norm([j0-j,0] + [0,i])> 4/ris)
            muro = 1;
            if(occ_mat(i,j)~=0)
       %     fprintf('STOPPPPPP')
            end
            break
        end
            if(~muro)
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
            if(A(1)>lgth|| A(1)==lgth)
                A(1) = lgth-1;
            end
           
            CC=[A(2),A(1)];
            Cost_map(wdt-CC(1),CC(2))= 2;
            
            end
    end
muro = 0;




end


end

