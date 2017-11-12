function [body, label, rf_x, rf_y, rf_z]=makerobot(this)
%MAKEROBOT produce the plot of the body in figure at initial position
% INPUT:
%  this = refer to this object
% OUTPUT: none

% set the axis and off block layer
hold on
axis equal

% set initial postion
x = this.q(1,1);
y = this.q(1,2);
theta =  this.q(1,3);

% compute the center of body
pos_x = x - this.length/2;
pos_y = y - this.width/2;

% set base vehicle display a circle radius equal to 1
% robot represent the scheme of plot
body = rectangle('Position',[pos_x pos_y this.width this.length], 'Curvature', [1 1], 'FaceColor',[0.5 0.5 0.5 0.5]);

% label print on robot the ID number
label = text(pos_x + .1, pos_y + .1, sprintf('ID: %i',this.ID));

% plot reference system
ver_x = 1 * this.rotationMatrix(theta);     % versor direction x
ver_y = ver_x * this.rotationMatrix(pi/2) ; % versor direction y
rf_x = quiver3(x, y, 0, ver_x(1), ver_x(2), 0, 'g');
rf_y = quiver3(x, y, 0, ver_y(1), ver_y(2), 0, 'r');
rf_z = quiver3(x, y, 0, 0, 0, 1, 'b');

% robot = [body, label, rf_x, rf_y, rf_z];
% trajectory = plot(this.q(1,1), this.q(1,2), '--r');


%
%
% pause(8);
% draw the animation from starting to end
trajectory = []; % set a new trajectory array

for i=2:length(this.EKF_q_store)


    % clean the previous reperesentation before start new frame
    delete(body);
    delete(label);
    delete(rf_x);
    delete(rf_y);
    delete(rf_z);

    % Actual trajectory
    if not(isempty(trajectory))
        delete(trajectory);
    end

    % Vehicle trajectory
    trajectory = plot(this.q(i,1), this.q(i,2));

    % update the Vehicle and label plot
%     newX = this.q(i,1) - this.width; % compute new position in x
%     newY = this.q(i,2) - this.width; % compute new position in y
    newX = this.q(i,1) - this.length/2;
    newY = this.q(i,2) - this.length/2;
    newtheta =  this.q(i,3);


    body = rectangle('Position',[newX, newY, this.width, this.length], 'Curvature', [1 1], 'FaceColor',[0.5 0.5 0.5 0.5]);
    label = text(newX + .1, newY + .1, sprintf('ID: %i',this.ID));

    % plot reference system
    ver_x = 1 * this.rotationMatrix(newtheta);     % versor direction x
    ver_y = ver_x * this.rotationMatrix(pi/2) ; % versor direction y
    rf_x = quiver3(this.q(i,1), this.q(i,2), 0, ver_x(1), ver_x(2), 0, 'g');
    rf_y = quiver3(this.q(i,1), this.q(i,2), 0, ver_y(1), ver_y(2), 0, 'r');
    rf_z = quiver3(this.q(i,1), this.q(i,2), 0, 0, 0, 1, 'b');

    % Update figures and process callbacks
    drawnow;
end

% set the axis and off block layer
hold off
end
