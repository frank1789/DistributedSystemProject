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
if ~isempty(this.distance{piterator})   % check vector of measure is non void
    % local variable
    %     matrixdistance = [this.distance{piterator}; this.laserTheta]; % [distance angle]
    indexmindistance = find(this.distance{piterator}(1,:) == min(this.distance{piterator}(1,:))); %index of minimum distance
    n = (ceil(length(this.distance{piterator})/2)); % compute center vector'measure
    %     mindistance = min(this.distance{piterator}(1,:)); % store minimum distance
    index = find(isnan(this.test(1,:)));
    %     lastindex = indexmindistance;
    %     lastindex == true && this.q(end,3) == this.steerangle
    
    i_lower  = index(index < (n - 1));
    i_higher = index(index > (n + 1));
    if min(this.distance{piterator}(1,:)) < 0.8 || min(this.distance{piterator}(1,:)) > -0.8 && ~isnan(this.distance{piterator}(1,n))
        switch find(min(this.distance{piterator}(1,:))) > n
            case 0
                this.steerangle = pi/2; %round(this.laserTheta(1,min(i_higher)),7);
               
            case 1
                this.steerangle = pi/2;%round(this.laserTheta(1,max(i_lower)),7);
              
            otherwise
                this.steerangle = pi;
                
        end
    else
        this.steerangle = 0;
        %     end % check mindistance
    end
    
end % if measure vector is empty
% this.plotangle(end+1) = this.steerangle;
end % function
