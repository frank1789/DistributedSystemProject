%% Start multirobot
close all;
clear class;
clear;
clc;

% load map
MapName = 'map_square.mat';
mapStuct = load( MapName );
mapStuct.map.points = [[0 16 16 0]; [0 0 16 16]];
% more wall
mapStuct.map.points = [ mapStuct.map.points, [12 12; 12 10],[12 12; 14 16],[13 6; 10 10],[4 4; 4 0],[4 8; 4 4]];
mapStuct.map.lines = [mapStuct.map.lines,[5;6], [7;8], [9;10], [11;12], [13;14]];

figure(800)
hold on
plotMap(mapStuct.map);
hold off
axis equal
grid on
pause(3);
close(800);
% time sample
MdlInit.Ts = 0.05;
% Length of simulation
MdlInit.T = 400;

%cost parameter
beta=0.5;

nit = MdlInit.T / MdlInit.Ts;  %Total application iteration

% Vehicle set-up initial conditions
Vehicle.q{1} = [1 1 0];
Vehicle.q{2} = [1 4 4/5*pi];
Vehicle.q{3} = [5 8 -pi/4];
robot = cell.empty;
for jj = 1:3
    robot{jj} = Robot(jj, MdlInit.T, MdlInit.Ts, Vehicle.q{jj});
end


 robot{1}.setpointtarget([1,15,0]);
 robot{2}.setpointtarget([15,15,0]);
 robot{3}.setpointtarget([10,12,0]);

run CI_initialize.m

scambio = zeros(3);

tic

%% Online Simulation of all 3 Robot 

    for ii = 1:1:nit
      for i = 1:length(robot)
            if mod(ii,2) == 0 % simualte laserscan @ 10Hz
                robot{i}.scanenvironment(mapStuct.map.points, mapStuct.map.lines, ii);        
            end
            robot{i}.UnicycleKinematicMatlab(ii);
       end
           
        for rr = 1:1:length(robot)
            
           %If lidar information is avaible update Global Map of each robot
           if mod(ii,20) == 0   %Update Global & Cost Map 1 Hz every 1s
               
             laserScan_xy{ii} = robot{rr}.laserScan_2_xy(ii);
    
             if(isempty(laserScan_xy{1,ii}{1,1}) || all((all(isnan(laserScan_xy{1,ii}{1,1})))==1))
    
             else
                 
                 %Update Global map
                 Update_gbmap(robot{rr},ii,wdt,lgth,occ_mat,lid_mat,laserScan_xy);
                 if mod(ii,40)==0
                     %Compute Cost matrix
                     Cost_map(:,:,rr)  = Update_vis( Cost_map(:,:,rr),robot{rr},ii,wdt,lgth,occ_mat,ris ); %ToDo da rivedere
                     %Reset Target Location
                     robot{rr}.setpointtarget(Reset_Target(robot{rr},ris,Cost_map(:,:,rr),ii));
                 end
             end
             
           end
           
           
             for vv = 1:1:length(robot)
                if (mod(ii,20) == 0 && vv~=rr &&  sqrt( (robot{rr}.q(ii,1) - robot{vv}.q(ii,1))^2 +  (robot{rr}.q(ii,2) - robot{vv}.q(ii,2))^2 )< 6)   %Settare un controllo sulla distanza e dare un intervallo che non lo faccia ripetere subito dopo

                           Utilities_Manage(robot,vv,ris,Cost_map,ii);
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


           end
   % end
    
toc



%% Animation
% pre-allocating for speed
body = cell.empty;
label = cell.empty;
rf  = cell.empty;
rf_x= cell.empty;
rf_y= cell.empty;
rf_z= cell.empty;
cl_point = cell.empty;
cloudpoint = cell.empty;
% setup figure
figure();
for n= 1:30:length(robot{1}.t)
    title(['Time: ', num2str(robot{1}.t(n),5)])
    hold on
    axis([0, 48, 0, 48]); axis equal; grid on;
    plotMap(mapStuct.map);
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
%         cloudpoint{j} = (robot{j}.getlaserscan(n)); % local variable cluodpoint
%         if ~isempty(cloudpoint{j}) % verify cloudpoint is nonvoid vector
%             [cl_point{j}] = plot(cloudpoint{j}(1,:),cloudpoint{j}(2,:),'.b'); % plot
%         end
%         if isempty(cl_point)
%             delete([cl_point]);
%         end
    end
    hold off
end % animation

figure
mesh(Global_map(:,:,1))
figure
mesh(Global_map(:,:,2))
figure
mesh(Global_map(:,:,3))


%save test_3.mat