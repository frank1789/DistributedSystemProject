function [body, label, rf_x, rf_y, rf_z] = animate(this, it)
%ANIMATE produce the plot of the body in figure at initial position
% INPUT:
%  this = refer to this object
%  it = (int) iterator from cycle
% OUTPUT: none

% set the axis and off block layer
hold on
axis equal

% initialize new poses
x = this.q(it,1);
y = this.q(it,2);
theta =  this.q(it,3);

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
end