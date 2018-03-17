%% Main file
close all
clear class
clear
clc

%% Generating map
% build a new map with map = Map("new",widht,height);
% or load an existing one map = Map("load")
map = Map('load'); %Map("new",100,100);%
figure(800); axis equal
map.plotMap();

%% set-up simulation parameters
% Sampling time
MdlInit.Ts = 0.05;
% Length of simulation
MdlInit.T = 25;
time = 0:MdlInit.Ts:MdlInit.T;

%% Vehicle set-up initial conditions
a = Robot(1, MdlInit.T, MdlInit.Ts, map.getAvailablePoints());
% set 1st target
a.setpointtarget([14 2 0]);

%% Perfrom simulation
w = waitbar(0,'Please wait simulation in progress...');
for indextime = 1:1:length(time)
    if mod(indextime,2) == 0 % simualte laserscan @ 10Hz
        a.scanenvironment(map.points, map.lines, indextime);
    end
    a.UnicycleKinematicMatlab(indextime);

    waitbar(indextime/length(time), w, ...
        sprintf('Please wait simulation in progress... %3.2f%%',...
        indextime/length(time) * 100));
end
close(w); clear w; % delete ui

% update measure
    a.prediction(indextime);
    a.update(indextime);
    a.store(indextime);

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
for n= 1:1:length(time)
    title(['Time: ', num2str(time(n),5)])
    hold on
    fa = quiver(a.q(n,1), a.q(n,2),a.target(1)-a.q(n,1), a.target(2)-a.q(n,2),'c');
    plot(a.target(1), a.target(2), '*r')
    plot(a.q(:,1), a.q(:,2), 'g-.')
    for j=1:1
        if n == 1
            [body{j}, label{j}, rf_x{j}, rf_y{j}, rf_z{j}] =a.makerobot(n);
        else
            delete([body{j}, label{j},  rf_x{j}, rf_y{j}, rf_z{j}]);
            [body{j}, label{j},  rf_x{j}, rf_y{j}, rf_z{j}] =a.animate(n);
        end
        
        drawnow;
    end
    % local variable cluodpoint
    cloudpoint = (a.getlaserscan(n));
    if ~isempty(cloudpoint) % verify cloudpoint is not empty vector
        cl_point = plot(cloudpoint(1,:),cloudpoint(2,:),'.g'); % plot 
    end
    if ~isempty(cl_point)
        delete(cl_point);
    end
    delete(fa);
end % end animation
hold off
clear body label rf_x rf_y rf_z cloudpoint % remove draw variables