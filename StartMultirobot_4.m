%% Main - Start multirobot
close all
clear class
clear
clc
addpath('Utility-Mapping')

%% Generating map
% build a new map with map = Map("new",widht,height);
% or load an existing one map = Map("load")
map = Map('new',100,100);
figure(800); axis equal
map.plotMap();
% time sample
MdlInit.Ts = 0.05;
% Length of simulation
MdlInit.T = 400;

%cost parameter
beta=0.5;

nit = MdlInit.T / MdlInit.Ts;  %Total application iteration

% preallocate
robot = cell.empty;
occparamters = cell.empty;
pf = cell.empty;

% Vehicle set-up initial conditions jj = 1:3
for jj = 1:3
    %initialize robot and destination
    robot{jj} = Robot(jj, MdlInit.T, MdlInit.Ts, map.getAvailablePoints());
    robot{jj}.setpointtarget(map.getAvailablePoints());
    %initialize parameters for occupacy & cost function
    [ occparamters{jj} ] = cinitialize(robot{jj}, map, nit, 0.15);
end

%% Online Simulation of all 3 Robot

for ii = 1:1:nit
    for i = 1:1:length(robot)
        if mod(ii,2) == 0 % simualte laserscan @ 10Hz
            robot{i}.scanenvironment(map.points, map.lines, ii);
        end
        robot{i}.UnicycleKinematicMatlab(ii);
        robot{i}.ekfslam(ii);
        if ii == 1
            pf{i} = Particle_Filter(robot{i}, map.landmark, ii);
        else
            pf{i}.update(robot{i}, nit, ii);
        end
    end
    
    for rr = 1:1:length(robot)
        %If lidar information is avaible update Global Map of each robot
        if mod(ii,20) == 0   %Update Global & Cost Map 1 Hz every 1s ii =20
            
            %Update Global map
            Update_gbmap(robot{rr},ii,occparamters{rr}.wdth,occparamters{rr}.lgth,occparamters{rr}.occ_mat,occparamters{rr}.lid_mat,occparamters{rr}.ris);
            
            if(isempty(robot{rr}.laserScan_2_xy{ii}))
                robot{rr}.setpointtarget(Reset_Target(robot{rr},occparamters{rr}.ris,occparamters{rr}.Cost_map(:,:),ii));
            else
                
                
                if mod(ii,40)==0  % ii = 40
                    fprintf('aggiorno il target sulla mappa iterazione: %5i\n', ii);
                    %Compute Cost matrix
                    occparamters{rr}.Cost_map(:,:)  = Update_vis(occparamters{rr}.Cost_map(:,:),robot{rr},ii,occparamters{rr}.wdth,occparamters{rr}.lgth,occparamters{rr}.occ_mat,occparamters{rr}.lid_mat,occparamters{rr}.ris ); %ToDo da rivedere
                    %Reset Target Location
                    robot{rr}.setpointtarget(Reset_Target(robot{rr},occparamters{rr}.ris,occparamters{rr}.Cost_map(:,:),ii));
                end
            end
            
        end
        
        
        %  for vv = 1:1:length(robot)
        if (mod(ii,400) == 0)   %Settare un controllo sulla distanza e dare un intervallo che non lo faccia ripetere subito dopo
            %       Utilities_Manage(robot,rr,ris,Cost_map,ii);
        end
    end
end


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
    axis([0, 16, 0, 16]); axis equal; grid on;
    map.plotMap();
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