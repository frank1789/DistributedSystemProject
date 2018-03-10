function this = checkinput(this, matchedStr, varargin)
switch char(matchedStr)
    case {'Load', 'load', 'LOAD'}
           this = setFromFile(this);
    case{'New', 'new', 'NEW'}
        this.setdimension(varargin{:});
        return
end % switch
end % function