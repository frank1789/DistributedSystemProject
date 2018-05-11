function this = checkinput(this, matchedStr, varargin)
% checkinput verify the string and call correct function
switch char(matchedStr)
    case {'Load', 'load', 'LOAD'}
        this = setFromFile(this);
    case{'New', 'new', 'NEW'}
        this = this.setdimension(varargin{:});
        % generate map
        if(~isempty(this.width) && ~isempty(this.height))
            fprintf("Start to create new map...\n")
            fprintf("Take a while...");
            [data] = this.mapgen(this.width, this.height);
            this.data = uint8(data);
            this = this.setpoints(data);
            this = this.setAvailablePoints(data);
            vert = this.setverticalsegment(data);
            horz = this.sethorizontalsegment(data);
            this.lines = horzcat(vert, horz);
            fprintf("Done\n")
            fprintf("Start to show plot\n");
        end % if 
end % switch
end % function