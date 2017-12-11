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
%  steerangle (double) = angle

% if ~isempty(this.distance{piterator})
%     this.mindistance = min(this.distance{piterator});
%     fprintf('check distance: %f\n', this.mindistance);
% end

% check minimun distance from obstacle
if ~isempty(this.distance{piterator}) %|| this.steerangle ~= 0 % check vector of measure is non void
    % local variable
    matrixdistance = [this.distance{piterator}; this.laserTheta]; % [distance angle]
    indexmindistance = find(matrixdistance(1,:) == min(matrixdistance(1,:))); %index of minimum distance
    n = (ceil(length(matrixdistance)/2)); % compute center vector'measure
    mindistance = min(matrixdistance(1,:)); % store minimum distance
    index = find(isnan(this.test(1,:)));
    i_lower  = index(index < (n - 1));
    i_higher = index(index > (n + 1));
    
    if ~isempty(mindistance) % check mindistance is empty
        
        if mindistance < 1.5  && ~isnan(matrixdistance(1,n)) ...
                && (this.q(1,3) < (pi/4 - 0.1) || this.q(1,3) > (pi/4 + 0.1))
            
            % select indicies where is nan
            if indexmindistance > n % turn in opposite of minimum distance
                i_lower =i_lower(i_lower < n);
                this.steerangle = this.laserTheta(1,max(i_lower));
            else
                i_higher=   i_higher(i_higher > n);
                this.steerangle = this.laserTheta(1,min(i_higher));
            end
        elseif ~isnan(all(mindistance)) && ~isnan(matrixdistance(1,n)) ...
                && (wrapToPi(this.q(1,3)) >= (pi/4 - 0.1) && wrapToPi(this.q(1,3)) <= (pi/4 + 0.1))
            %             disp('tutti diversi da NaN')
            this.steerangle = pi/2;
        elseif mindistance < 1.5  || ~isnan(matrixdistance(1,n)) ...
                && this.q(1,3) > pi/2
                % select indicies where is nan
            if max(index) < n % turn in opposite of minimum distance
                i_lower = i_lower(i_lower < n);
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
