function multirobot(n_robot, Simulation_Time, map, attempt_number)
%MULTIROBOT
MdlInit.Ts = 0.05;              % time sample
MdlInit.T = Simulation_Time;    % Length of simulation
nit = MdlInit.T / MdlInit.Ts;   %Total application iteration
% preallocate
robot = cell.empty;
occparameters = cell.empty;
pf = cell.empty;

% Vehicle set-up initial conditions
for jj = 1:n_robot
    % initialize robot and destination
    robot{jj} = Robot(jj, MdlInit.T, MdlInit.Ts, map.getAvailablePoints(),map,0.15);
    robot{jj} = robot{jj}.setpointtarget(map.getAvailablePoints());
    % initialize parameters for occupacy & cost function
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
        if ii == 1
            pf{i} = Particle_Filter(robot{i}, map.landmark, ii);
        else
            pf{i} = pf{i}.update(robot{i}, ii);
            robot{i} = robot{i}.setParticleFilterxEst(pf{i}.xEst);
        end
    end
    
    for rr = 1:1:length(robot)
        occparameters{rr}.already_visit = 0;
        % If lidar information is avaible update Global Map of each robot
        if mod(ii,20) == 0   %Update Global & Cost Map @ 1 Hz(1s)
            if ii > 300
                %Update Global map
                Update_gbmap(robot{rr},ii,occparameters{rr});
            end
            
            if mod(ii,300) == 0
                [occparameters{rr}.already_visit] = AlreadyPass(robot{rr}.q(1:ii-1,1:2),robot{rr}.q(ii,1:2));
            end
            % set target in base of visibility matrix
            if (occparameters{rr}.already_visit && ii>  occparameters{rr}.it_needed)
                [itneeded,target] = Reset_Main_Target(robot{rr},ii,occparameters{rr});
                occparameters{rr}.it_needed = itneeded + ii;
                robot{rr}.setpointtarget(target);
            elseif (ii > occparameters{rr}.it_needed)
                robot{rr} = robot{rr}.setpointtarget(Reset_Target_2(robot{rr}, ii,...
                    occparameters{rr}));
            end
            
            if mod(ii,40) == 0  % ii = 40
                % Update visibility Matrix
                occparameters{rr}.Cost_map(:,:) = Update_vis(occparameters{rr},robot{rr},ii);
            end
        end
        
        if (mod(ii,2) == 0 && ~occparameters{rr}.comunication)
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
namefile = ['n_robot_',num2str(n_robot),...
    '_Sim_time_',num2str(Simulation_Time),...
    '_attempt_num_',num2str(attempt_number),'.mat'];
save(namefile,'robot','occparameters','pf','map','Simulation_Time');
end
