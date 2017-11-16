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

for p = 1:3
a  = Robot(1, MdlInit.T, MdlInit.Ts, Vehicle.q{p});
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

laserScan_xy = a.laserScan_xy();


% figure, clf 


figure('position', [320, 150, 1440, 900]), clf , hold on
t = linspace(1, MdlInit.T, 201);


grid on
plotMap(mapStuct.map);

body = cell.empty;
label = cell.empty;
rf_x  = cell.empty;
rf_y  = cell.empty;
rf_z  = cell.empty;
limit= cell.empty;
laserbeam = cell.empty;
theta2 = linspace(-90 * pi/180, 90 * pi/180, round(180/0.36));


for n= 1:length(t)
    subplot(2,1,1);
    axis([-10, 10, -10, 10]);
    hold on
    axis equal
    grid on
    plotMap(mapStuct.map);
    for j=1:1
        if n == 1
            [body{j}, label{j}, rf_x{j}, rf_y{j}, rf_z{j}] =a.makerobot(n);
%             limit{j} = a.plotlaserbeam(n);
        else
            delete([body{j}, label{j}, rf_x{j}, rf_y{j}, rf_z{j}]);
            [body{j}, label{j}, rf_x{j}, rf_y{j}, rf_z{j}] =a.animate(n);
            %             limit{j} = a.plotlaserbeam(n);
            %             while 1
            %                 for i = 1:length(theta2)
            %                     delete(laserbeam{i});
            %                     laserbeam{i} = a.animatelaser(n)
            %                     ray = line([0 R*cos(theta2(i))],[0 R*sin(theta2(i))],'color','r');
            %                     endray = plot(R*cos(theta2(i)),R*sin(theta2(i)),'r*');
            %                     b = toc(a); % check timer
            %     disp(b);
            %     if b > (1/10)
            %                     drawnow % update screen every 1/30 seconds
            %         a = tic; % reset timer after updating
            %             disp(a);
            %         drawnow;
        end
    end
    hold off
    
    
    drawnow limitrate;
    subplot(2,1,2);
    grid on
    hold on
    plot(laserScan_xy(1,n),laserScan_xy(2,n),'.b');
    hold off
    axis equal
    grid on
    
    
    
    
    
    
end % end animation
% hold off
%
% subplot(2,1,2);
% hold on
% plot(laserScan_xy(1,:),laserScan_xy(2,:),'.b');
% hold off
% axis equal
% grid on
end
