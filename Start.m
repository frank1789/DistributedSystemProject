%% Main file
close all;
clear all;
clear class;
clc;
addpath ('Cost Function', 'Occupacy grid from Image')
%  diary log.txt
% load map
MapName = 'map_square.mat';
mapStuct = load( MapName );
% mapStuct.map.points = [ mapStuct.map.points, [4 4; -1 5]];
% mapStuct.map.lines = [mapStuct.map.lines,[5;6]];

mapStuct.map.points = [[0 16 16 0]; [0 0 16 16]];
% mapStuct.map.points = [ mapStuct.map.points, [12 12; 10 16]];
% mapStuct.map.lines = [mapStuct.map.lines,[5;6]];
% 
mapStuct.map.points = [ mapStuct.map.points, [12 12; 12 10],[12 12; 14 16],[13 6; 10 10],[4 4; 4 0],[4 8; 4 4]];
mapStuct.map.lines = [mapStuct.map.lines,[5;6], [7;8], [9;10], [11;12], [13;14]];

figure(800)
hold on
plotMap(mapStuct.map);
hold off

axis equal
grid on
% pause(1); close(figure(800));
p=1;

%% simulation
% Sampling time
MdlInit.Ts = 0.05;

% Length of simulation
MdlInit.T = 97;
nit = 0:MdlInit.Ts:MdlInit.T; 

% Vehicle set-up Vehicle initial conditions
Vehicle.q{1} = [1, 1, -pi];
% Vehicle.q{2} = [1 1; pi];
% Vehicle.q{3} = [-7; 3; 0];
a  = Robot(1, MdlInit.T, MdlInit.Ts, Vehicle.q{p}); % istance robot

theta=-pi/2:0.36*pi/180:pi/2;
ris = 0.015;
r0=4/ris;

y=r0*sin(theta);
x=r0*cos(theta);

x_g=floor(x);
y_g=floor(y);

max_x = max(x_g);
max_y = max(y_g);

n_mis = 201;%length(laserScan_xy);

occ_mat = zeros(max_x,2*max_y,n_mis);
lid_mat = zeros(max_x,2*max_y,n_mis);

laserScan_xy = cell.empty;
jj=1;


a.setpointtarget([9 15 0]);

w = waitbar(0,'Please wait simulation in progress...');

tic
steps = length(nit);
for ii = 1:1:length(nit)
    if mod(ii,2) == 0 % simualte laserscan @ 10Hz
        a.scanenvironment(mapStuct.map.points, mapStuct.map.lines, ii);
    end
    a.UnicycleKinematicMatlab(ii);
    
    %         laserScan_xy{ii} = a.laserScan_xy(ii);
    %
    %         if(isempty(laserScan_xy{1,ii}{1,1}) || all((all(isnan(laserScan_xy{1,ii}{1,1})))==1))
    %
    %         else
    %             out = laserScan_xy{1,ii}{1,1}(:,all(~isnan(laserScan_xy{1,ii}{1,1})));
    %             [ occ_mat(:,:,jj)] = Occ_Grid( occ_mat(:,:,jj),lid_mat(:,:,jj),out);
    %             jj=jj+1;
    %         end
    waitbar(ii/steps,w,sprintf('Please wait simulation in progress... %3.2f%%',ii/steps *100))
end
close(w)
diary off

for i = 2:a.getEKFstep()
    a.prediction(i);
    a.update(i);
    a.store(i);
end
toc

%% Animation
filename = sprintf('testAnimated%s.gif', num2str(p));
h = figure('position', [320, 150, 1440, 900]); clf, hold on
t = linspace(1, MdlInit.T, 201);
grid on
plotMap(mapStuct.map);

body = cell.empty;
label = cell.empty;
rf_x  = cell.empty;
rf_y  = cell.empty;
rf_z  = cell.empty;
limit= cell.empty;
yl = [];

qui= cell.empty;

for n= 1:1:length(a.t)
%     subplot(2,1,1);
    
    title(['Time: ', num2str(a.t(n),5)])
    axis([0, 18, 0, 18]);
    hold on
    axis equal
    grid on
    fa = quiver(a.q(n,1), a.q(n,2),a.target(1)-a.q(n,1), a.target(2)-a.q(n,2),'c');
%     qui{n}= plotrepforce(a.laserScan_xy{n}, a.q(n,:));
%     if ~isempty(a.laserScan_xy{n})
%         delete(yl)
%         for k = 1 : length( a.laserScan_xy{n})
%             x = a.distance{n}(1,k);
%             y = a.laserScan_xy{n}(2,k);
%             yl = line([a.q(n,1),x+a.q(n,1)], [a.q(n,2),a.q(n,2)+y],'Color','red','LineStyle',':');
%          end
%     end
    
    plot(a.target(1), a.target(2), '*r')
    plot(a.q(n,1), a.q(n,2), 'b-o')
    hold on
    plot(a.q(:,1), a.q(:,2), 'g-.')
    hold off
    plotMap(mapStuct.map);
    for j=1:1
        if n == 1
            [body{j}, label{j}, rf_x{j}, rf_y{j}, rf_z{j}] =a.makerobot(n);
        else
            delete([body{j}, label{j}, rf_x{j}, rf_y{j}, rf_z{j}]);
            [body{j}, label{j}, rf_x{j}, rf_y{j}, rf_z{j}] =a.animate(n);
        end
        drawnow;
    end
    hold off
    delete(fa)
%     if ~isempty(qui{n})
%         delete(qui{n})
%     end
    
    % cloudpoint laserscan
%     subplot(2,1,2); grid on;
    % local variable cluodpoint
    cloudpoint = (a.getlaserscan(n));
    % verify cloudpoint is nonvoid vector
    if ~isempty(cloudpoint)
        cl_point = plot(cloudpoint(1,:),cloudpoint(2,:),'.b'); % plot
    end
    axis equal
    grid on
end % end animation
%
%
% for i=1:1:j-1
%     figure
%     mesh(occ_mat(:,:,i));
% end
%%
%  mex -output passadati Src/test.cpp Src/PFM.cpp Src/robotinterface.cpp


