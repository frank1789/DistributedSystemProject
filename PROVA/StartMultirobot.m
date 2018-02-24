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
MdlInit.T = 90;

nit = MdlInit.T / MdlInit.Ts;

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
tic
for i = 1:length(robot)
    for ii = 1:1:nit
        if mod(ii,2) == 0 % simualte laserscan @ 10Hz
            robot{i}.scanenvironment(mapStuct.map.points, mapStuct.map.lines, ii);
        end
        robot{i}.UnicycleKinematicMatlab(ii);
    end
end
toc
%%
% for ii = 1:1:nit
%     if mod(ii,2) == 0
%         robot2.scanenvironment(mapStuct.map.points, mapStuct.map.lines, ii);
%     end
%     robot2.UnicycleKinematicMatlab(ii);
% end
%
% for ii = 1:1:nit
%     if mod(ii,2) == 0
%         robot3.scanenvironment(mapStuct.map.points, mapStuct.map.lines, ii);
%     end
%
%
%     robot3.UnicycleKinematicMatlab(ii);
%
%     %     laserScan_xy{ii} = a.laserScan_xy(ii);
%
%     %     if(isempty(laserScan_xy{1,ii}{1,1}) || all((all(isnan(laserScan_xy{1,ii}{1,1})))==1))
%     %
%     %     else
%     %         out = laserScan_xy{1,ii}{1,1}(:,all(~isnan(laserScan_xy{1,ii}{1,1})));
%     %         [ occ_mat(:,:,j)] = Occ_Grid( occ_mat(:,:,j),lid_mat(:,:,j),out);
%     %         j=j+1;
%     %     end
% end

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
for n= 1:10:length(robot{1}.t)
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