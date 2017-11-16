function laserbeam = plotlaserbeam(this, it)
theta2 = linspace(-90 * pi/180, 90 * pi/180, round(180/0.36));
a = tic; % start timer
% figure(), clf
% grid on;
% axis equal;
% axis([-10 10 -10 10])
% hold on

% compute the extreme point of limit beam ray
% start point
startlimitx = this.q(it,1);
startlimity = this.q(it,2);
% end point positive
positive_endlimitx =  this.q(it,1) + this.lasermaxdistance * this.rotationMatrix(this.q(it,3));
positive_endlimity =  this.q(it,2) + this.lasermaxdistance * this.rotationMatrix(this.q(it,3));
% end point negative
negative_endlimitx =  this.q(it,1) - this.lasermaxdistance * this.rotationMatrix(this.q(it,3));
negative_endlimity =  this.q(it,2) - this.lasermaxdistance * this.rotationMatrix(this.q(it,3));

% fprintf('startx: %.3f\tstarty: %.3f\tendx: %.3f\tendy: %.3f\t\n', startlimitx, startlimity, positive_endlimitx(1), positive_endlimity(2));
% fprintf('startx: %.3f\tstarty: %.3f\tnendx: %.3f\tnendy: %.3f\t\n', startlimitx, startlimity, negative_endlimitx(1), negative_endlimity(2));
% generate limit lines FOV
positvelimit = line([startlimitx positive_endlimitx(1)],[startlimity positive_endlimity(2)]);
neagtivelimit = line([startlimitx negative_endlimitx(1)],[startlimity negative_endlimity(2)]);

% compute arch line FOV
% xunit = r * cos(th) + x;
% yunit = r * sin(th) + y;

rx =   this.lasermaxdistance * this.rotationMatrix(this.q(it,3));
ry = - this.lasermaxdistance * this.rotationMatrix(this.q(it,3));
xunit = rx(1) * cos(theta2 - this.q(it,3)) + this.q(it,1);
yunit = ry(2) * sin(theta2- this.q(it,3)) + this.q(it,2);
arcg = plot(xunit, yunit);

% arcg = plot(x, y);
% collecet FOV
FOV = [positvelimit, neagtivelimit];
% compute marker ray position
laserbeam_marker = plot(positive_endlimitx(1), positive_endlimity(2),'r*');
laserbeam_line = line([this.q(it,1) positive_endlimitx(1)],[this.q(it,2) positive_endlimity(2)],'color','r');
% collect object
laserray = [laserbeam_marker, laserbeam_line];

laserbeam = [FOV, laserray];
%  while 1
% for i = 1:length(theta2)
%      delete(ray);
%      delete(endray);
%      ray = line([this.q(it,1) endlimitx(1)*cos(theta2(i))],[this.q(it,2) endlimity(2)*sin(theta2(i))],'color','r');
%      endray = plot(this.lasermaxdistance*cos(theta2(i)),this.lasermaxdistance*sin(theta2(i)),'r*');
% %     b = toc(a); % check timer
% %     disp(b);
% %     if b > (1/10)
% %         drawnow % update screen every 1/30 seconds
% %         a = tic; % reset timer after updating
% %         %             disp(a);
% %         %         drawnow;
% %     end
%  end
%  end
end
