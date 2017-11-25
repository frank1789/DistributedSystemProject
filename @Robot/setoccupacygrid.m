function [occupacygrid] = setoccupacygrid(this, it)
%SETOCCUPACYGRID method generates a plot by scanning the laser sensor
% as scattered points in the plane, so this plot is converted into a frame
% and analyzed as an image by returning the occupacy grid as a
% matrix [m, n] (double)
% INPUT:
%  this (object) = refer to this object
%  it (int) = iterator from the loop to locate the step
% OUTPUT:
%  occupacygrid (double) = matrix [m, n]

persistent lastoccupacygrid; % store the last occupacy grid

if it <= 2
    % from cell arry to vector and store in local variable cluodpoint
    cloudpoint = this.laserScan_xy{it};
    % initialize the occupacy grid with same probability for every cell
    occupacygrid = zeros(420,540) + 0.5;
    lastoccupacygrid = occupacygrid;
else
    cloudpoint = this.laserScan_xy{it};
    if ~isempty(cloudpoint) % verify cloudpoint is nonvoid vector
        prepareframe = figure();
        set(prepareframe, 'Visible', 'off');
        plot(cloudpoint(1,:),cloudpoint(2,:),'.b'); % generate plot at specific position
        F = getframe(prepareframe); % transform frame to image
        [X, Map] = frame2im(F);
        set(gca,'box','off');
%         imshow(X);
        imagesc(X);
        imageNorm = double(X)/255;
        % return the occupacy grid
        occupacygrid = 1 - imageNorm(:,:,1);
        % store occupacy grid in static variable
        lastoccupacygrid = occupacygrid;
    else
        % recall the last occupacy grid when the scan is void
        occupacygrid = lastoccupacygrid;
    end
end
end % definition method
