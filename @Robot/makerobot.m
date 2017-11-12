function makerobot(this, vehicle)

% instaziate vehicle position
x = vehicle(1);
y = vehicle(2);
orientation = vehicle(3);

pos_x = x - this.length/2;
pos_y = y - this.width/2;

hold on
axis equal

% set base vehicle display a circle radius equal to 1
% robot represent the scheme of plot
robot = rectangle('Position',[pos_x pos_y this.width this.length], 'Curvature', [1 1], 'FaceColor',[0.5 0.5 0.5 0.5]);

% label print on robot the ID number
label = text(pos_x + .1, pos_y + .1, sprintf('ID: %i',this.ID));

% reference system

% quiver(x + this.q(1)*cos(this.q(3)), y, 0, 1, 'r')

% % g = hgtransform;
% quiver(x,y,0,1,'Parent',g)
% set(g,'Matrix',makehgtform('xrotate',this.q(3)))


% quiver(x, y, 1, 0, 'g')
% quiver3(x, y, 0, 0, 0, 1, 'b')

% trajectory = plot(this.q(1,1), this.q(1,2), '--r');





% draw the animation from starting to end
trajectory = []; % set a new trajectory array

for i=2:length(this.EKF_q_store)
    
    
    % clean the previous reperesentation before start new frame
    delete(robot);
    delete(label);
    
    % Actual trajectory
    if not(isempty(trajectory))
        delete(trajectory);
    end
    
    % Vehicle trajectory
    trajectory = plot(this.EKF_q_store(1,i), this.EKF_q_store(2,i));
    
    % update the Vehicle and label plot
    newX = this.EKF_q_store(1,i) - this.width; % compute new position in x
    newY = this.EKF_q_store(2,i) - this.width; % compute new position in y
    robot = rectangle('Position', [newX, newY - this.width, this.width, this.length], 'Curvature', [1 1], 'FaceColor',[0.5 0.5 0.5 0.5]);
    label = text(newX + .1, newY + .1, sprintf('ID: %i',this.ID));
    
    % Update figures and process callbacks
    drawnow;
end

% set the axis and off block layer
hold off
axis equal
end


