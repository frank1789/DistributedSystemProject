%% Main file
close all;
clear all;
clear class;
clc;
addpath ('Cost Function', 'Occupacy grid from Image')
% diary log.txt
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
pause(1); close(figure(800));
p=1;

%% simulation
% Sampling time
MdlInit.Ts = 0.05;
% Length of simulation
MdlInit.T = 44;
nit = 0:MdlInit.Ts:MdlInit.T;
% Vehicle set-up Vehicle initial conditions
Vehicle.q{1} = [1, 2, 0];
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

n_mis = 1000;%length(laserScan_xy);

occ_mat = zeros(max_x,2*max_y);
lid_mat = zeros(max_x,2*max_y);

room_length = 17;
room_width  = 17;

lgth =  floor(room_length/ris);
wdt  =  floor(room_width/ris);

Global_map = zeros(lgth,wdt);
Cost_map = zeros(lgth,wdt);

center_x = floor(lgth/2);
center_y = floor(wdt/2);

laserScan_xy = cell.empty;
j=1;
kk=1;

% use this method to set target
a.setpointtarget([15 15 0]);

w = waitbar(0,'Please wait simulation in progress...');

tic
steps = length(nit);
for ii = 1:1:length(nit)
    if mod(ii,2) == 0 % simualte laserscan @ 10Hz
        a.scanenvironment(mapStuct.map.points, mapStuct.map.lines, ii);
    end
    a.UnicycleKinematicMatlab(ii);
    
              laserScan_xy{ii} = a.laserScan_2_xy(ii);
    
             if(isempty(laserScan_xy{1,ii}{1,1}) || all((all(isnan(laserScan_xy{1,ii}{1,1})))==1))
    
             else
                 out = laserScan_xy{1,ii}{1,1}(:,all(~isnan(laserScan_xy{1,ii}{1,1})));
                 [ occ_mat(:,:)] = Occ_Grid( occ_mat(:,:),lid_mat(:,:),out);
                 
                 
                  
                          for i = 1:1:266
                            for j = 1:1:532
                                %In questo modo non considera l'angolo ma
                                %se lo si fa fatto per bene i calcoli sono
                                %troppo lunghi o si trova un modo
                                %efficiente di farli o v? trovato
                                %un'escamotage
%                                 if(i==1 && j==1)
%                                          A     = [cos(a.q(ii,3)), -sin(a.q(ii,3)), a.q(ii,1)/0.015; 
%                                                   sin(a.q(ii,3)),  cos(a.q(ii,3)), a.q(ii,2)/0.015;  
%                                                     0                 0             1]*[i ;267-j; 1]; 
%                                             A=floor(A);
%                                             CC=[A(2)+33,A(1)+33];
%                                             cc = zeros(size(occ_mat(:,:)))+10;
%                                             if(wdt-CC(1)+133>wdt)
%                                                    Cost_map(wdt-CC(1):wdt,CC(2):CC(2)+133) = zeros(size(CC(1),133))-10;
%                                             else if(CC(2)+133>lgth)
%                                                    Cost_map(wdt-CC(1):wdt-CC(1)+133,CC(2):lgth) = zeros(size(133,lgth-CC(2)))-10;
%                                                 else 
%                                                     Cost_map(wdt-CC(1):wdt-CC(1)+133,CC(2):CC(2)+133) = zeros(size(133,133))-10;
%                                                     
%                                                 end
%                                                 
%                                             end
%                                             
%                                 end
                                 if(occ_mat(i,j)~=0)
                                         A     = [cos(a.q(ii,3)), -sin(a.q(ii,3)), a.q(ii,1)/0.015; 
                                                  sin(a.q(ii,3)),  cos(a.q(ii,3)), a.q(ii,2)/0.015;  
                                                    0                 0             1]*[i ;267-j; 1]; 
                                            A=floor(A);
                                            CC=[A(2)+33,A(1)+33]; 
                                            if(Global_map(wdt-CC(1),CC(2))==0) 
                                            Global_map(wdt-CC(1),CC(2))= occ_mat(i,j); 
                                            else
                                            Global_map(wdt-CC(1),CC(2))= (occ_mat(i,j) + Global_map(wdt-CC(1),CC(2)))/2; 
                                            end
                                end
                                
                            end
                          end 
             end
      kk=kk+1;
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
% pre-allocating for speed
body = cell.empty;
label = cell.empty;
rf  = cell.empty;   
rf_x= cell.empty;
rf_y= cell.empty;
rf_z= cell.empty;
% setup figure
figure();
for n= 1:30:length(a.t)
    title(['Time: ', num2str(a.t(n),5)])
    axis([0, 18, 0, 18]); hold on; axis equal; grid on;
    hold on
    plotMap(mapStuct.map);
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
    hold off
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

mesh(Global_map)

save test.mat


 
 
%% Initial Condition
n=1;
    title(['Time: ', num2str(a.t(n),5)])
    axis([0, 18, 0, 18]); hold on; axis equal; grid on;
    hold on
    plotMap(mapStuct.map);
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
    hold off
    % local variable cluodpoint
    cloudpoint = (a.getlaserscan(n));
    % verify cloudpoint is nonvoid vector
    if ~isempty(cloudpoint)
        cl_point = plot(cloudpoint(1,:),cloudpoint(2,:),'.b'); % plot
    end
    axis equal
    grid on

    
%% Final Condition
figure
n=length(a.t);
    title(['Time: ', num2str(a.t(n),5)])
    axis([0, 18, 0, 18]); hold on; axis equal; grid on;
    hold on
    plotMap(mapStuct.map);
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
    hold off
    % local variable cluodpoint
    cloudpoint = (a.getlaserscan(n));
    % verify cloudpoint is nonvoid vector
    if ~isempty(cloudpoint)
        cl_point = plot(cloudpoint(1,:),cloudpoint(2,:),'.b'); % plot
    end
    axis equal
    grid on
    
    
spac = 3;
Cost_map = Global_map;
for i =1 :1 : 1133
    for j=1:1:1133
        if(Cost_map(i,j) ~= 0)
            Cost_map(i,j-spac:j+spac) = Cost_map(i,j-spac:j+spac);
        end
    end
end
