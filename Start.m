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

% Sampling time
MdlInit.Ts = 0.05;

% Length of simulation
MdlInit.T = 10;

% j = Robot(324, MdlInit.T, MdlInit.Ts, [0; 1; pi/4])


%% Vehicle set-up Vehicle initial conditions
Vehicle.q{1} = [0; 1; pi/4];
Vehicle.q{2} = [1; 1; pi];
Vehicle.q{3} = [-7; 3; 0];


a  = Robot(1, MdlInit.T, MdlInit.Ts, Vehicle.q{1});
a.UnicycleKinematicMatlab();
a.EncoderSim();
for i = 2:a.getEKFstep()
    a.tempame(mapStuct.map.points, mapStuct.map.lines, i);
    a.prediction(i);
    a.update(i);
    a.store(i);
end

% a.tempame(mapStuct.map.points, mapStuct.map.lines, 1);
% t = timer('TimerFcn', 'stat=false; disp(''Timer!'')',...
%                  'StartDelay',0.10);


%     start(t)
%     stat=true;
%     while(stat==true)
%     disp('.')
%     robota{nrobot}.tempame(mapStuct.map.points, mapStuct.map.lines);
%     pause(0.1)
% end
figure, clf , hold on
subplot(2,1,1);
t = linspace(1, MdlInit.T, 201);
% figure('position', [320, 150, 1440, 900]), clf , hold on
axis([-10, 10, -10, 10]);
grid on
plotMap(mapStuct.map);

body = cell.empty;
label = cell.empty;
rf_x  = cell.empty;
rf_y  = cell.empty;
rf_z  = cell.empty;


for n= 1:length(t)
    for j=1:1
        if n == 1
            [body{j}, label{j}, rf_x{j}, rf_y{j}, rf_z{j}] =a.makerobot(n);
        else
            delete([body{j}, label{j}, rf_x{j}, rf_y{j}, rf_z{j}]);
            [body{j}, label{j}, rf_x{j}, rf_y{j}, rf_z{j}] =a.animate(n);
        end
    end
    
    drawnow limitrate;
end
hold off
laserScan_xy = a.laserScan_xy();
subplot(2,1,2);
hold on
plot(laserScan_xy(1,:),laserScan_xy(2,:),'.b');
hold off
axis equal
grid on
