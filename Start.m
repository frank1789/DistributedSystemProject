%% Main file
clear all;
clear class;
close all;
clc;

addpath ('Cost Function', 'Occupacy grid from Image')

% load map
MapName = 'map_square.mat';
mapStuct = load( MapName );
mapStuct.map.points = [ mapStuct.map.points, [4 4; -1 5]];  
mapStuct.map.lines = [mapStuct.map.lines,[5;6]];  

figure(800)
hold on
plotMap(mapStuct.map);
hold off
axis equal
grid on
pause(1); close(figure(800));
p=1;
% Sampling time
MdlInit.Ts = 0.05;

% Length of simulation
MdlInit.T = 20;

nit = MdlInit.T / MdlInit.Ts;

% Vehicle set-up Vehicle initial conditions
Vehicle.q{1} = [0, 0, 0];
Vehicle.q{2} = [1; 1; pi];
Vehicle.q{3} = [-7; 3; 0];
%

a  = Robot(1, MdlInit.T, MdlInit.Ts, Vehicle.q{p});

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
j=1;


for ii = 1:1:nit
    
    if mod(ii,2) == 0
        a.scanenvironment(mapStuct.map.points, mapStuct.map.lines, ii);
    end

    a.UnicycleKinematicMatlab(ii);

    laserScan_xy{ii} = a.laserScan_xy(ii);
    
    if(isempty(laserScan_xy{1,ii}{1,1}) || all((all(isnan(laserScan_xy{1,ii}{1,1})))==1))
        
    else
        out = laserScan_xy{1,ii}{1,1}(:,all(~isnan(laserScan_xy{1,ii}{1,1})));
        [ occ_mat(:,:,j)] = Occ_Grid( occ_mat(:,:,j),lid_mat(:,:,j),out);
        j=j+1;
    end
end



%%

for i = 2:a.getEKFstep()
    a.prediction(i);
    a.update(i);
    a.store(i);
end

%% Animation
figure, clf, hold on
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

for n= 1:1:length(a.t)
    subplot(2,1,1);

    title(['Time: ', num2str(a.t(n),5)])
    axis([-10, 10, -10, 10]);
    hold on
    axis equal
    grid on
    plotMap(mapStuct.map);
    for j=1:1
        if n == 1
            [body{j}, label{j}, rf_x{j}, rf_y{j}, rf_z{j}] =a.makerobot(n);
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
        drawnow;
    end
    hold off
    
    
    
    subplot(2,1,2);
    grid on
    
    % transform cell arry to vector and store in local variable cluodpoint
    cloudpoint = (a.getlaserscan(n));
    % verify cloudpoint is nonvoid vector
    if ~isempty(cloudpoint)
        cl_point = plot(cloudpoint(1,:),cloudpoint(2,:),'.b'); % plot
    end
    axis equal
    grid on
    
    %     % store gif
    %     frame = getframe(h);
    %       im = frame2im(frame);
    %       [imind,cm] = rgb2ind(im,256);
    %       % Write to the GIF File
    %       if n == 1
    %           imwrite(imind,cm,filename,'gif', 'Loopcount',inf);
    %       else
    %           imwrite(imind,cm,filename,'gif','WriteMode','append');
    %       end
end % end animation


for i=1:1:j-1
    figure
    mesh(occ_mat(:,:,i));
end

