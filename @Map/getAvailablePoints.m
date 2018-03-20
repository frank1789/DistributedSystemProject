function [ point ] = getAvailablePoints(this)
% getAvailablePoints extract point from matrix by indicies for robot
% position.
% incoming matrix and extracts the indices, so store in field points.
% @param [in] input = matrix from map generator

try
    x = randi(length(this.available));
    point = [this.available(:,x).', 0];
catch
%     while true
        help = msgbox({'Please select a point in the figure to proceed', ...
            'click with the left mouse button'}, 'Select point','help');
        uiwait(help);
        [x,y] = ginput(1);
%         A = floor([x,y]);
%         if ~isempty(ismember(A,this.points','rows'))
            point = [x y 0]; %break
%         else
%             disp('selezione non valida')
%         end%if
%     end % while
    
end % try-catch

end % function