function this = detectangle(this, piterator)
% DETECTANGLE determines the best angle for steering in the opposite direction
% to that of the obstacle.
% In detail:
% Check that the measure vattore is not empty at the i-th iteration or that
% the angle is non-zero.
% The indexes of the position of the minimum measurement are obtained with
% respect to the angle sector.
% It is compared that the vector of the minimum distances is not empty.
% Compare the minimum distance to a security and that the distance to the
% center of the FOV is not a NaN
% Compare the index of the minimum distance and choose the angle in the
% opposite direction.
% Otherwise the steering angle is 0.
% INPUT:
%  this (object) = refer to this object
%  piterator (int) = step of simulation
% OUTPUT:
%  this(object) = refer to this object
%  (double) = last row of time computed by ode45 [n, m]
%  q(double) = last row of time computed by ode45 [n, m]

if ~isempty(this.distance{piterator})
    this.mindistance = min(this.distance{piterator});
    fprintf('check distance: %f\n', this.mindistance);
end

% check minimun distance from obstacle
if ~isempty(this.distance{piterator}) || this.steerangle ~= 0 % check vector of measure is non void
    localscan = this.getlaserscan(piterator);
    % local variable
    matrixdistance = [this.distance{piterator}; this.laserTheta]; % [distance angle]
    indexmindistance = find(matrixdistance(1,:) == min(matrixdistance(1,:))); %index of minimum distance
    n = (ceil(length(matrixdistance)/2)); % compute center vector'measure
    mindistance = min(matrixdistance(1,:)); % store minimum distance
    if ~isempty(mindistance) % check mindistance is empty
        if mindistance < 1.5  && ~isnan(matrixdistance(1,n))
            % select indicies where is nan
            if indexmindistance > n % turn in opposite of minimum distance
                i_lower =i_lower(i_lower < n);
                this.steerangle = this.laserTheta(1,min(i_lower));
            else
                i_higher=   i_higher(i_higher > n);
                this.steerangle = this.laserTheta(1,max(i_higher));
            end
        else
            this.steerangle = 0;
        end
    end % check mindistance
end % if vector of measure
end % function
