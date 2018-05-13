%% Main - Start multirobot
close all

clearvars -except map
clc
addpath('Utility-Mapping')

%% Generating map
% build a new map with:
% map = Map("New", width, heigth);
% map = Map("New", width, heigth, #landmark, "auto");
% map = Map("New", width, heigth, #landmark, "manual");
% or load an existing one:
% map = Map("Load");
% map = Map("Load", #landamark);
% map = Map("Load", #landamark, "auto");
% map = Map("Load", #landamark, "manual");
map = Map('new',40,40);
%0figure(801); axis equal
%map.plotMap();
% time sample
MdlInit.Ts = 0.05;
% Length of simulation
MdlInit.T = 1200;

%cost parameter
beta=0.5;
itneeded =0;
comunication = 0;

nit = MdlInit.T / MdlInit.Ts;  %Total application iteration

% preallocate
robot = cell.empty;
occparameters = cell.empty;
pf = cell.empty;

% Vehicle set-up initial conditions jj = 1:3
for jj = 1:1
    %initialize robot and destination
    robot{jj} = Robot(jj, MdlInit.T, MdlInit.Ts, map.getAvailablePoints(),map,0.15);
    robot{jj} = robot{jj}.setpointtarget(map.getAvailablePoints());
    %initialize parameters for occupacy & cost function
    [ occparameters{jj} ] = cinitialize(robot{jj}, map, nit, 0.15);
end

%% Online Simulation of all 3 Robot
w = waitbar(0,'Please wait simulation in progress...');
for ii = 1:1:nit
    for i = 1:1:length(robot)
        if mod(ii,2) == 0 % simualte laserscan @ 10Hz
            robot{i} = robot{i}.scanenvironment(map.points, map.lines, ii);
        end
        robot{i} = robot{i}.UnicycleKinematicMatlab(ii);
        %       robot{i} = robot{i}.ekfslam(ii);
        if ii == 1
            pf{i} = Particle_Filter(robot{i}, map.landmark, ii);
        else
            pf{i} = pf{i}.update(robot{i}, ii);
            robot{i} = robot{i}.setParticleFilterxEst(pf{i}.xEst);
        end
    end
    
    for rr = 1:1:length(robot)
        occparameters{rr}.already_visit = 0;
        %If lidar information is avaible update Global Map of each robot
        if mod(ii,20) == 0   %Update Global & Cost Map 1 Hz every 1s ii =20
            
            if ii > 300
                %Update Global map
                Update_gbmap(robot{rr},ii,occparameters{rr});
            end
            
            if (occparameters{rr}.already_visit && ii>  occparameters{rr}.it_needed)    %  set target in base of visibility matrix
                
                [itneeded,target] = Reset_Main_Target(robot{rr},ii,occparameters{rr});
                fprintf('aggiorno il target sulla mappa iterazione: %5i\n', robot{rr}.target)
                fprintf('it needed: %5i\n', itneeded)
                occparameters{rr}.it_needed = itneeded +ii;
                robot{rr}.setpointtarget(target);
                
            elseif (ii>  occparameters{rr}.it_needed)
                robot{rr}.setpointtarget(Reset_Target_2(robot{rr},ii, occparameters{rr}));
            end
            
            
            if mod(ii,40)==0  % ii = 40
                fprintf('aggiorno cost_map %5i\n', ii);
                %Update visibility Matrix
                occparameters{rr}.Cost_map(:,:)  = Update_vis(occparameters{rr},robot{rr},ii); %ToDo da rivedere
            end
        end
        
        if (mod(ii,2) == 0 && ~occparameters{rr}.comunication)   %  dare un intervallo che non lo faccia ripetere subito dopo
            [occparameters] = comunicate(robot,ii,rr,occparameters);
        end
        % Reset Comunication Parameter when a given temporal delay is overcame
        if(occparameters{rr}.comunication)
            occparameters{rr}.delay = occparameters{rr}.delay +1;
        end
        
        if(occparameters{rr}.delay >100)
            occparameters{rr}.comunication = 0;
            occparameters{rr}.delay = 0;
        end
    end
    waitbar(ii/nit, w, sprintf('Please wait simulation in progress... %3.2f%%', ii/nit * 100))
end
close(w); clear w;

% %% Animation
% % pre-allocating for speed
% body = cell.empty;
% label = cell.empty;
% rf  = cell.empty;
% rf_x= cell.empty;
% rf_y= cell.empty;
% rf_z= cell.empty;
% cl_point = cell.empty;
% cloudpoint = cell.empty;
% % setup figure
% figure(); hold on;
% for n= 1:length(robot{1}.t)
%     title(['Time: ', num2str(robot{1}.t(n),5)])
%     hold on;
%     axis equal; grid on;
%
%     for j = 1:1:length(robot)
%         plot(robot{j}.target(1), robot{j}.target(2), '*r')
%         plot(robot{j}.q(:,1), robot{j}.q(:,2), 'g-.')
%         if n == 1
%             [body{j}, label{j}, rf_x{j}, rf_y{j}, rf_z{j}] = robot{j}.makerobot(n);
%         else
%             delete([body{j}, label{j}, rf_x{j}, rf_y{j}, rf_z{j}]);
%             [body{j}, label{j}, rf_x{j}, rf_y{j}, rf_z{j}] = robot{j}.animate(n);
%         end
%
% %         cloudpoint{j} = drawscan(robot{j},pf{j}, n); % local variable cluodpoint
% %         if ~isempty(cloudpoint{j}) % verify cloudpoint is nonvoid vector
% %             [cl_point{j}] = plot(cloudpoint{j}(1,:),cloudpoint{j}(2,:),'.b'); % plot
% %         end
%     end
%     drawnow;
%     hold off
% end % animation
% hold off
%
% %% check trajectories
% for z = 1:length(robot)
%     figure(); hold on; axis equal;
%     plot(robot{z}.q(:,1),robot{z}.q(:,2),'b')
%     %plot(robot{z}.EKF_q_store(1,:),robot{z}.EKF_q_store(2,:))
%     plot(pf{z}.xEst(:,1),pf{z}.xEst(:,2),'r')
%     hold off
% end