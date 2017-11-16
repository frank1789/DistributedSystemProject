%% Main file
close all;
clear class;
clear
clc;

% load map
MapName = 'map_square.mat';
mapStuct = load( MapName );

figure(800)
hold on
plotMap(mapStuct.map);
hold off
axis equal
grid on




% setup robot
v = 1;
omega = 0;

% Sampling time
MdlInit.Ts = 0.05;

% Length of simulation
MdlInit.T = 10;

% j = Robot(324, MdlInit.T, MdlInit.Ts, [0; 1; pi/4])


%% Vehicle set-up

% Vehicle initial conditions
Vehicle.q{1} = [0; 1; pi/4];
Vehicle.q{2} = [1; 1; pi];
Vehicle.q{3} = [-7; 3; 0];


% a  = Robot(1, MdlInit.T, MdlInit.Ts);
% b = Robot(32, MdlInit.T, MdlInit.Ts);
% c = Robot(-100, MdlInit.T, MdlInit.Ts);
% a.UnicycleKinematicMatlab(Vehicle.q3);
% a.EncoderSim();


% for i = 2:a.PropValue()
%     a.prediction(i);
%     a.update(i);
%     a.store(i);
% end

clear i
robota =cell.empty;
% t = timer('TimerFcn', 'stat=false; disp(''Timer!'')',...
%                  'StartDelay',0.10);

for nrobot = 1:3
    robota{nrobot} = Robot(nrobot, MdlInit.T, MdlInit.Ts, Vehicle.q{nrobot});
    robota{nrobot}.UnicycleKinematicMatlab();
%     start(t)
%     stat=true;
%     while(stat==true)
%     disp('.')
%     robota{nrobot}.tempame(mapStuct.map.points, mapStuct.map.lines);
%     pause(0.1)
% end
    robota{nrobot}.EncoderSim();
    for i = 2:robota{nrobot}.getEKFstep()
        robota{nrobot}.prediction(i);
        robota{nrobot}.update(i);
        robota{nrobot}.store(i);
    end
end

t = linspace(1, MdlInit.T, 201);
figure('position', [320, 150, 800, 600]), clf , hold on
axis([-40, 40, -40, 40]);
grid on

body = cell.empty;
label = cell.empty;
rf_x  = cell.empty;
rf_y  = cell.empty;
rf_z  = cell.empty;


for n= 1:length(t)
    for j=1:3
        
        if n == 1

            [body{j}, label{j}, rf_x{j}, rf_y{j}, rf_z{j}] =robota{j}.makerobot(n);
        else
            delete([body{j}, label{j}, rf_x{j}, rf_y{j}, rf_z{j}]);
        [body{j}, label{j}, rf_x{j}, rf_y{j}, rf_z{j}] =robota{j}.animate(n);
        end
    end

    drawnow limitrate;
end
hold off

% figure(1), clf('reset') , hold on
% axis([-10, 10, -10, 10]);
% grid on
% for j = 2:length(robota{1}.q)
%      robota{1}.animate(j);
%      robota{2}.animate(j);
%      robota{3}.animate(j);
%
% end
%
% hold off;

% b.UnicycleKinematicMatlab(MdlInit, Vehicle);
% c.UnicycleKinematicMatlab(MdlInit, Vehicle);
% robota={};
% for i = 1:2
%     robota{i} = Robot(i);
% %     robota{i}.makerobot();
% end
%
% figure('position', [320, 150, 800, 600]), clf , hold on
% axis([-10, 10, -10, 10]);
% grid on
%  a.makerobot(Vehicle.q3)
% % figure()
% %  b.makerobot()
%
