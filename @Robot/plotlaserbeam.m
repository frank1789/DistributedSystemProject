function [laserbeam] = plotlaserbeam(this, t)
%PLOTLASERBEAM method to plot the laser beam for laser sensor
% INPUT:
%  this = refer to this object
%  t (int) = initial step of animation
% OUTPUT:
%   laserbeam (object) = return object plot

theta2 = linspace(-90 * pi/180, 90 * pi/180, round(180/0.36));
% compute the extreme point of limit beam ray
% start point
startlimitx = this.q(t,1);
startlimity = this.q(t,2);

% end point positive
positive_endlimitx =  this.q(t,1) + this.lasermaxdistance * this.rotationMatrix(this.q(t,3));
positive_endlimity =  this.q(t,2) + this.lasermaxdistance * this.rotationMatrix(this.q(t,3));

% end point negative
negative_endlimitx =  this.q(t,1) - this.lasermaxdistance * this.rotationMatrix(this.q(t,3));
negative_endlimity =  this.q(t,2) - this.lasermaxdistance * this.rotationMatrix(this.q(t,3));

% generate limit lines FOV
positvelimit = line([startlimitx positive_endlimitx(1)],[startlimity positive_endlimity(2)]);
neagtivelimit = line([startlimitx negative_endlimitx(1)],[startlimity negative_endlimity(2)]);

% compute arch line FOV
% xunit = r * cos(th) + x;
% yunit = r * sin(th) + y;

% rx =   this.lasermaxdistance * this.rotationMatrix(this.q(t,3));
% ry = - this.lasermaxdistance * this.rotationMatrix(this.q(t,3));
xunit = positive_endlimitx(1) * cos(theta2); %* this.rotationMatrix(this.q(t,3));
yunit = negative_endlimitx(1) * sin(theta2); %* this.rotationMatrix(this.q(t,3));
% x = [];
% y = [];
% for n = 1:length(xunit)
%     x = xunit(n) * this.rotationMatrix(this.q(t,3));
%     y = yunit(n) * this.rotationMatrix(this.q(t,3));
% end
arcg = plot(xunit, yunit);
% arcg* this.rotationMatrix(this.q(t,3));

% collecet FOV
FOV = [positvelimit, neagtivelimit, arcg];

% compute marker ray position
laserbeam_marker = plot(positive_endlimitx(1), positive_endlimity(2),'r*');
laserbeam_line = line([this.q(t,1) positive_endlimitx(1)],[this.q(t,2) positive_endlimity(2)],'color','r');
% collect object
laserray = [laserbeam_marker, laserbeam_line];

%return complete laserbeam
laserbeam = [FOV, laserray];
end
