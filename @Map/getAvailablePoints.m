function [ point ] = getAvailablePoints(this)
% getAvailablePoints extract point from matrix by indicies for robot
% position.
% incoming matrix and extracts the indices, so store in field points.
% @param [out] point - coordinate of point selected

try
    x = randi(length(this.available));
    point = [this.available(:,x).', 0];
catch
    pointmax = max(this.points(1,:));
    pointmin = min(this.points(1,:));
    while true
        help = msgbox({'Please select a point in the figure to proceed', ...
            'click with the left mouse button'}, 'Select point','help');
        uiwait(help);
        [x,y] = ginput(1);
        if x > pointmin && x < pointmax && y > pointmin && y < pointmax
            point = [x y 0];
            break
        else
            err = errordlg('Invalid selection','Error');
            uiwait(err);
        end % if
    end % while
end % try-catch
end % function