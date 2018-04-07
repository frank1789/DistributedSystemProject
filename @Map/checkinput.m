function this = checkinput(this, matchedStr, varargin)
% checkinput verify the string and call correct function
switch char(matchedStr)
    case {'Load', 'load', 'LOAD'}
        this = setFromFile(this);
    case{'New', 'new', 'NEW'}
        this.setdimension(varargin{:});
end % switch
end % function