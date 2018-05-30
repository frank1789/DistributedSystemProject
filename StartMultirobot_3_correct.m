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
MdlInit.T = 800;
nit = 0:MdlInit.Ts:MdlInit.T;
% Vehicle set-up Vehicle initial conditions
Vehicle.q{1} = [2, 2, 0];
% Vehicle.q{2} = [1 1; pi];
% Vehicle.q{3} = [-7; 3; 0];
a  = Robot(1, MdlInit.T, MdlInit.Ts, Vehicle.q{p}); % istance robot

theta=-pi/2:0.36*pi/180:pi/2;
ris = 0.15;
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

room_length = 16;
room_width  = 16;

lgth =  floor(room_length/ris);
wdt  =  floor(room_width/ris);

Global_map = zeros(lgth,wdt,3);
Cost_map = zeros(lgth-1,wdt-1,3);

center_x = floor(lgth/2);
center_y = floor(wdt/2);

laserScan_xy = cell.empty;
j=1;
kk=1;
zz=1;

A = zeros(3);
front = zeros(2);

% use this method to set target
a.setpointtarget([13 13 0]);

w = waitbar(0,'Please wait simulation in progress...');

tic
steps = length(nit);
% Vehicle set-up initial conditions
Vehicle.q{1} = [1 1 0];
Vehicle.q{2} = [5 5 4/5*pi];
Vehicle.q{3} = [6 1 -pi/4];
robot = cell.empty;
for jj = 1:3
    robot{jj} = Robot(jj, MdlInit.T, MdlInit.Ts, Vehicle.q{jj});
end


robot{1}.setpointtarget([1,15,0]);
robot{2}.setpointtarget([15,15,0]);
robot{3}.setpointtarget([10,12,0]);

for ii = 1:1:length(nit)
for rr=1:1:3
    if mod(ii,2) == 0 % simualte laserscan @ 10Hz
        robot{rr}.scanenvironment(mapStuct.map.points, mapStuct.map.lines, ii);
    end
    robot{rr}.UnicycleKinematicMatlab(ii);
    
    
    if mod(ii,10)==0
              if(isempty(robot{rr}.laserScan_2_xy{ii}) || all((all(isnan(robot{rr}.laserScan_2_xy{ii})))==1))
            
               else
                 out = robot{rr}.laserScan_2_xy{ii}(:,all(~isnan(robot{rr}.laserScan_2_xy{ii})));
                 [ occ_mat(:,:)] = Occ_Grid( occ_mat(:,:),lid_mat(:,:),out);
                  
                  
                  
                          for i = 1:1:length(occ_mat(:,1))
                           for j = 1:1:length(occ_mat(1,:))
                                
                              if mod(ii,40)==0
                                    
                                         %  Compute Cost matrix
                                         A     = [cos(robot{rr}.q(ii,3)), -sin(robot{rr}.q(ii,3)), robot{rr}.q(ii,1)/ris; 
                                                  sin(robot{rr}.q(ii,3)),  cos(robot{rr}.q(ii,3)), robot{rr}.q(ii,2)/ris;  
                                                    0                 0             1]*[i ;(length(occ_mat(1,:)))/2+1-j; 1]; 
                                            A=floor(A);
                                            if(A(2)>wdt || A(2)==wdt)
                                            A(2) = wdt-1; 
                                            end
                                            if(A(2)==0 || A(2)<0)
                                                A(2)=1;
                                            end
                                            if(A(1)==0 || A(1)<0)
                                                A(1)=1;
                                            end
                                            if(A(1)>lgth)
                                            A(1) = lgth; 
                                            end
                                            CC=[A(2),A(1)];
                                            Cost_map(wdt-CC(1),CC(2))= 5;%min(10,Cost_map(wdt-CC(1),CC(2)) +10/(i^2+j^2-2)^0.25);
                                            
                                            %Reset Target Location

                                                                       
                                                  y=0.15*r0*sin(theta+robot{rr}.q(ii,3))+robot{rr}.q(ii,2);
                                                  x=0.15*r0*cos(theta+robot{rr}.q(ii,3))+robot{rr}.q(ii,1); 
                                                  front = [x;y];
                                          
                                                 for ll = 1:1:250
                                                    if(isnan(robot{rr}.laserScan_2_xy{1,ii}(1,251-ll)) && front(1,251-ll)>0 && front(2,251-ll)>0)
                                                      robot{rr}.setpointtarget([front(1,251-ll) front(2,251-ll) 0]);
                                                                break
                                                         else if(isnan(robot{rr}.laserScan_2_xy{1,ii}(1,251+ll))&& front(1,251+ll)>0 && front(2,251+ll)>0)
                                                                 robot{rr}.setpointtarget([front(1,251+ll) front(2,251+ll) 0]);
                                                                 break
                                                              end
                                                    end
                                                 end
                                                
                                                 if mod(ii,160)==0
                                                  [raw,column] = minmat(Cost_map);
                                                  new_target =[ceil(column*0.15);ceil(17-raw*0.15);1];
                                                  robot{rr}.setpointtarget([new_target(1) new_target(2) 0]);
                                                  end
                              end
                              
                            end
                          end 
              end
      kk=kk+1;
    waitbar(ii/steps,w,sprintf('Please wait simulation in progress... %3.2f%%',ii/steps *100))
    end
   if mod(ii,2)==0
Global_map(:,:,rr) = Update_gbmap(Global_map(:,:,rr),robot{rr},ii,wdt,lgth,occ_mat,lid_mat); 
   end
   end
end
close(w)
diary off

% for i = 2:a.getEKFstep()
%     a.prediction(i);
%     a.update(i);
%     a.store(i);
% end
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

figure
mesh(Global_map)
figure
mesh(Cost_map)

%save test.mat


%  
%  
% %% Initial Condition
% n=1;
%     title(['Time: ', num2str(a.t(n),5)])
%     axis([0, 18, 0, 18]); hold on; axis equal; grid on;
%     hold on
%     plotMap(mapStuct.map);
%     fa = quiver(a.q(n,1), a.q(n,2),a.target(1)-a.q(n,1), a.target(2)-a.q(n,2),'c');
%     plot(a.target(1), a.target(2), '*r')
%     plot(a.q(:,1), a.q(:,2), 'g-.')
%     for j=1:1
%         if n == 1
%             [body{j}, label{j}, rf_x{j}, rf_y{j}, rf_z{j}] =a.makerobot(n);
%         else
%             delete([body{j}, label{j},  rf_x{j}, rf_y{j}, rf_z{j}]);
%             [body{j}, label{j},  rf_x{j}, rf_y{j}, rf_z{j}] =a.animate(n);
%         end
%         drawnow;
%     end
%     hold off
%     % local variable cluodpoint
%     cloudpoint = (a.getlaserscan(n));
%     % verify cloudpoint is nonvoid vector
%     if ~isempty(cloudpoint)
%         cl_point = plot(cloudpoint(1,:),cloudpoint(2,:),'.b'); % plot
%     end
%     axis equal
%     grid on
% 
%     

    
    
    
    
%     
%     
%                                       %Update Global Map         
%                                 if(occ_mat(i,j)~=0)
%                                          A     = [cos(robot{rr}.q(ii,3)), -sin(robot{rr}.q(ii,3)), robot{rr}.q(ii,1)/ris; 
%                                                    sin(robot{rr}.q(ii,3)),  cos(robot{rr}.q(ii,3)), robot{rr}.q(ii,2)/ris;  
%                                                      0                 0             1]*[i ;(length(occ_mat(1,:)))/2+1-j; 1]; 
%                                              A=floor(A);
%                                             if(A(2)>wdt || A(2)==wdt)
%                                             A(2) = wdt-1; 
%                                             end
%                                             if(A(2)==0 || A(2)<0)
%                                                 A(2)=1;
%                                             end
%                                             if(A(1)==0 || A(1)<0)
%                                                 A(1)=1;
%                                             end
%                                             if(A(1)>lgth)
%                                             A(1) = lgth; 
%                                             end
%                                             CC=[A(2),A(1)];
%                                             if(Global_map(wdt-CC(1),CC(2))==0) 
%                                             Global_map(wdt-CC(1),CC(2),rr)= occ_mat(i,j); 
%                                             else
%                                             Global_map(wdt-CC(1),CC(2),rr)= (occ_mat(i,j) + Global_map(wdt-CC(1),CC(2),rr))/2; 
%                                             end
%                                  end
%     