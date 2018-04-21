function this = checkinput(this, matchedStr, varargin)
% checkinput verify the string and call correct function
switch char(matchedStr)
    case {'Load', 'load', 'LOAD'}
        this = setFromFile(this);
    case{'New', 'new', 'NEW'}
        this.setdimension(varargin{:});
        % generate map
        if(~isempty(this.width) && ~isempty(this.height))
            disp('Start to create new map!')
            disp('Take a while...');
            [data] = this.mapgen(this.width, this.height);
            this.setpoints(data);
            this.setAvailablePoints(data);
            vert = this.setverticalsegment(data);
            horz = this.sethorizontalsegment(data);
            this.lines = horzcat(vert, horz);
            disp('Complete!')
            disp('Show plot...');
        end % if 
end % switch
end % function