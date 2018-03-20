%% Main - Start multirobot
close all
clear class
clear
clc

%% Generating map
% build a new map with map = Map("new",widht,height);
% or load an existing one map = Map("load")
map = Map('load');
figure(800); axis equal
map.plotMap();

%% set-up simulation parameters
% Sampling time
MdlInit.Ts = 0.05;
% Length of simulation
MdlInit.T = 10;
time = 0:MdlInit.Ts:MdlInit.T;

%cost parameter
beta=0.5;

%% Vehicle set-up initial conditions
for jj = 1:3
    robot{jj} = Robot(jj, MdlInit.T, MdlInit.Ts, map.getAvailablePoints());
end


robot{1}.setpointtarget([1,15,0]);
robot{2}.setpointtarget([15,15,0]);
robot{3}.setpointtarget([10,12,0]);

target = zeros(2,3);
run CI_initialize.m

scambio = zeros(3);

tic

%% Online Simulation of all 3 Robot 

%% Online Simulation of all 3 Robot
for indextime = 1:length(time)
    if mod(indextime,2) == 0 % simualte laserscan @ 10Hz
        for i = 1:length(robot)
            robot{i}.scanenvironment(map.points, map.lines, indextime);
        end
           
        for rr = 1:1:3
            robot{rr}.UnicycleKinematicMatlab(ii);
            
           %If lidar information is avaible update Global Map of each robot
           if mod(ii,20) == 0   %Update Global & Cost Map 1 Hz every 1s
                        laserScan_xy{ii} = robot{rr}.laserScan_2_xy(ii);
    
             if(isempty(laserScan_xy{1,ii}{1,1}) || all((all(isnan(laserScan_xy{1,ii}{1,1})))==1))
    
             else
                 out = laserScan_xy{1,ii}{1,1}(:,all(~isnan(laserScan_xy{1,ii}{1,1})));
                 [ occ_mat(:,:)] = Occ_Grid( occ_mat(:,:),lid_mat(:,:),out);
               
                  for i = 1:1:length(occ_mat(:,1))
                            for j = 1:1:length(occ_mat(1,:))
                                      if mod(ii,40)==0
                                    
                                         %  Compute Cost matrix
                                         A     = [cos(robot{rr}.q(ii,3)), -sin(robot{rr}.q(ii,3)), robot{rr}.q(ii,1)/ris; 
                                                  sin(robot{rr}.q(ii,3)),  cos(robot{rr}.q(ii,3)), robot{rr}.q(ii,2)/ris;  
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
                                            Cost_map(wdt-CC(1),CC(2),rr)= 5;%min(10,Cost_map(wdt-CC(1),CC(2)) +10/(i^2+j^2-2)^0.25);
                                            
                                            %Reset Target Location

                                                                       
                                                  y=0.15*r0*sin(theta+robot{rr}.q(ii,3))+robot{rr}.q(ii,2);
                                                  x=0.15*r0*cos(theta+robot{rr}.q(ii,3))+robot{rr}.q(ii,1); 
                                                  front = [x;y];
                                          
                                                 for ll = 1:1:250
                                                    if(isnan(robot{rr}.laserScan_2_xy{1,ii}(1,251-ll)) && front(1,251-ll)>0 && front(2,251-ll)>0)
                                                      robot{rr}.setpointtarget([front(1,251-ll) front(2,251-ll) 0]);
                                                                break
                                                         else if(isnan(robot{rr}.laserScan_2_xy{1,ii}(1,251+ll))&& front(1,251+ll)>0 && front(2,251+ll)>0)
                                                                 robot{rr}.setpointtarget([front(1,251+ll) front(2,251+ll) 0]);
                                                                 break
                                                              end
                                                    end
                                                 end
                                                
                                                 if mod(ii,160)==0
                                                  [raw,column] = minmat(Cost_map(:,:,rr));
                                                  new_target =[ceil(column*0.15);ceil(17-raw*0.15);1];
                                                  robot{rr}.setpointtarget([new_target(1) new_target(2) 0]);
                                                  target(:,rr) = new_target(1:2);
                                                  end
                              end
                                if(occ_mat(i,j)~=0)
                                         A     = [cos(robot{rr}.q(ii,3)), -sin(robot{rr}.q(ii,3)), robot{rr}.q(ii,1)/0.015; 
                                                  sin(robot{rr}.q(ii,3)),  cos(robot{rr}.q(ii,3)), robot{rr}.q(ii,2)/0.015;  
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
                                            if(Global_map(wdt-CC(1),CC(2),rr)==0) 
                                            Global_map(wdt-CC(1),CC(2),rr)= occ_mat(i,j); 
                                            else
                                            Global_map(wdt-CC(1),CC(2),rr)= (occ_mat(i,j) + Global_map(wdt-CC(1),CC(2),rr))/2; 
                                            end
                                end
                            end
                   end
                 
                 
             end
             
           end
           
        end
    for rr = 1:length(robot)
        
        for ss = 1:1:3 % 3 numero robot
          if (mod(ii,20) == 0 && ss~=rr &&  sqrt( (robot{rr}.q(ii,1) - robot{ss}.q(ii,1))^2 +  (robot{rr}.q(ii,2) - robot{ss}.q(ii,2))^2 )< 6)   %Settare un controllo sulla distanza e dare un intervallo che non lo faccia ripetere subito dopo
                                                  
              
                                                  y=0.15*r0*sin(theta+robot{rr}.q(ii,3))+robot{rr}.q(ii,2);
                                                  x=0.15*r0*cos(theta+robot{rr}.q(ii,3))+robot{rr}.q(ii,1); 
                                                  front = [x;y];
                                          
                                                 for ll = 1:1:250
                                                    if(isnan(robot{rr}.laserScan_2_xy{1,ii}(1,251-ll)) && front(1,251-ll)>0 && front(2,251-ll)>0)
                                                      robot{rr}.setpointtarget([front(1,251-ll) front(2,251-ll) 0]);
                                                                break
                                                         else if(isnan(robot{rr}.laserScan_2_xy{1,ii}(1,251+ll))&& front(1,251+ll)>0 && front(2,251+ll)>0)
                                                                 robot{rr}.setpointtarget([front(1,251+ll) front(2,251+ll) 0]);
                                                                 break
                                                              end
                                                    end
                                                 end                  
              

                                U  = -20000;
                                idx = 0;

                                    for i=1:1:length(front(1,:))
                                        if(isnan(robot{rr}.laserScan_2_xy{1,ii}(1,i)) && front(1,i)>0 && front(2,i)>0)
                                            target(:,rr)=front(:,i);
                                            [ P ] = Utilities_Function( target,rr,3,4);  % 3 number of robot %4 max range
                                              
                                               PP=0;
                                                    for mm=1:1:length(robot) %number of robot
                                                            if(mm~=rr)
                                                            PP = PP + beta*norm(target(:,mm)-robot{mm}.q(ii,1:2));
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
                                        robot{rr}.setpointtarget([front(1,idx) front(2,idx) 0]);
                                    end
          end
        end
             %In case of possible comunication we weight the caming
             %information we the already avaible one.
               if(sqrt( (robot{2}.q(ii,1) - robot{1}.q(ii,1))^2 +  (robot{1}.q(ii,2) - robot{1}.q(ii,2))^2 )< 6)  %6 maximum distance of comunication
                   %problema Iniziale riduzione della probabilit? di zone gi? viste da parte di robot che non ancora lo hanno.
             
                   Global_map(:,:,1)=  0.8*Global_map(:,:,1) + 0.2*Global_map(:,:,2);
                   Global_map(:,:,2)=  0.2*Global_map(:,:,1) + 0.8*Global_map(:,:,2); 
                   
               end
               
               if(sqrt( (robot{3}.q(ii,1) - robot{1}.q(ii,1))^2 +  (robot{1}.q(ii,3) - robot{1}.q(ii,2))^2 )< 6)  %6 maximum distance of comunication
               
                   Global_map(:,:,1)=  0.8*Global_map(:,:,1) + 0.2*Global_map(:,:,3);
                   Global_map(:,:,3)=  0.2*Global_map(:,:,1) + 0.8*Global_map(:,:,3);
                   
               end
               
               if(sqrt( (robot{3}.q(ii,1) - robot{2}.q(ii,2))^2 +  (robot{1}.q(ii,3) - robot{2}.q(ii,2))^2 )< 6)  %6 maximum distance of comunication
               
                   Global_map(:,:,2)=  0.8*Global_map(:,:,2) + 0.2*Global_map(:,:,3);
                   Global_map(:,:,3)=  0.2*Global_map(:,:,2) + 0.8*Global_map(:,:,3);
                   
               end

        communicate(robot,ii)

           end
   % end
    
toc



%% Animation
% pre-allocating for speed
body = cell.empty;
label = cell.empty;  
rf_x= cell.empty;
rf_y= cell.empty;
rf_z= cell.empty;
% set-up figure
hold on; axis equal
figure(800);
for n= 1:30:length(robot{1}.t)
    title(['Time: ', num2str(robot{1}.t(n),5)])
    hold on
%     axis([0, 48, 0, 48]); axis equal; grid on;
    for j = 1:1:length(robot)
        plot(robot{j}.target(1), robot{j}.target(2), '*r')
        plot(robot{j}.q(:,1), robot{j}.q(:,2), 'g-.')
        if n == 1
            [body{j}, label{j}, rf_x{j}, rf_y{j}, rf_z{j}] = robot{j}.makerobot(n);
        else
            delete([body{j}, label{j}, rf_x{j}, rf_y{j}, rf_z{j}]);
            [body{j}, label{j}, rf_x{j}, rf_y{j}, rf_z{j}] = robot{j}.animate(n);
        end
        drawnow;
    end
    hold off
end % animation
clear body label rf_x rf_y rf_z

figure
mesh(Global_map(:,:,1))
figure
mesh(Global_map(:,:,2))
figure
mesh(Global_map(:,:,3))


%save test_3.mat