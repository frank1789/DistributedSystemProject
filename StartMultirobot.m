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
MdlInit.T = 20;

nit = MdlInit.T / MdlInit.Ts;  %Total application iteration

% Vehicle set-up initial conditions
Vehicle.q{1} = [8 6 0];
Vehicle.q{2} = [1 1 4/5*pi];
Vehicle.q{3} = [6 3 -pi/4];
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
        if mod(ii,2) == 0 % simualte laserscan @ 10Hz
            for i = 1:length(robot)
            robot{i}.scanenvironment(mapStuct.map.points, mapStuct.map.lines, ii);
            end
        end
           
        for rr = 1:1:3
            robot{rr}.UnicycleKinematicMatlab(ii);
            
           %If lidar information is avaible update Global Map of each robot
           if mod(ii,20) == 0   %Update Global Map 1 Hz every 1s
           run GM_make.m
           end
           
        end
        
        
          if mod(ii,100) == 0   %Check for other robot information 0.2 Hz every 5s
              
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
               
                ii=2;
                rr=1;
                r0=4;
                theta=-pi/2:0.36*pi/180:pi/2;
                y=r0*sin(theta);
                x=r0*cos(theta);
                for i = 1:1:501
 
               front(:,i)    =  [cos(robot{rr}.q(ii,3)), -sin(robot{rr}.q(ii,3)), robot{rr}.q(ii,1); 
                                       sin(robot{rr}.q(ii,3)),  cos(robot{rr}.q(ii,3)), robot{rr}.q(ii,2);  
                                           0                 0             1]*[x(i);y(i);1]; 
              
                end
                
                front(:,isnan(robot{rr}.laserScan_2_xy{1,ii}(1,:)))

           end
    end
    
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
    axis([0, 18, 0, 18]); axis equal; grid on;
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

k=1;
for rr = 1:1:3
    for i = 1:1:501
        if(isnan(robot{rr}.laserScan_2_xy{1,2}(1,i)))
               frontier(k,rr)=(180/501)*i;
               k=k+1;
        end
    end
    k=1;
end
%save test_3.mat