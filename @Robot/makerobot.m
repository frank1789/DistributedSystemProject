function [body, label, rf_x, rf_y, rf_z] = makerobot(this, t)
%MAKEROBOT produce the plot of the body in figure at initial position
% INPUT:
%  this = refer to this object
%  t (int) = initial step of animation
% OUTPUT:
%   body (object) = return object plot
%   label(object) = return object plot
%   rf_x (object) = return object plot
%   rf_y (object) = return object plot
%   rf_z (object) = return object plot


% set the axis and off block layer
hold on
axis equal

% set initial postion
x = this.q(t,1);
y = this.q(t,2);
theta =  this.q(t,3);

% compute the center of body
pos_x = x - this.length/2;
pos_y = y - this.width/2;

% set base vehicle display a circle radius equal to 1
% robot represent the scheme of plot

% xcir = (this.lasermaxdistance * cos(this.laserTheta)) .* this.rotationMatrix(theta) + x;
% ycir = (this.lasermaxdistance * sin(this.laserTheta)) * this.rotationMatrix(theta) + y;
FOV = [this.lasermaxdistance * cos(this.laserTheta); this.lasermaxdistance * sin(this.laserTheta)]' / this.rotationMatrix(theta) + [1 0];
xcir = FOV(:,1);
ycir = FOV(:,2);

body = [rectangle('Position',[pos_x pos_y this.width this.length], 'Curvature', [1 1], 'FaceColor',[0.5 0.5 0.5 0.5]),...
        line([FOV(1,1) FOV(end,1)], [FOV(1,2) FOV(end,2)]),...
        line(xcir,ycir)];
        %plot(this.lasermaxdistance*cos(this.laserTheta), this.lasermaxdistance*sin(this.laserTheta)) ];
% label print on robot the ID number
label = text(pos_x + .1, pos_y + .1, sprintf('ID: %i',this.ID));

% plot reference system
ver_x = 1 * this.rotationMatrix(theta);     % versor direction x
ver_y = ver_x * this.rotationMatrix(pi/2) ; % versor direction y
rf_x = quiver3(x, y, 0, ver_x(1), ver_x(2), 0, 'g');
rf_y = quiver3(x, y, 0, ver_y(1), ver_y(2), 0, 'r');
rf_z = quiver3(x, y, 0, 0, 0, 1, 'b');

hold off
end
