classdef Map < handle
    properties (SetAccess = 'private')
        width;
        height;
        nrooms;
        points = [];
        lines  = [];
    end
    
    properties (Constant, Access = 'private')
        validStrings = ["New", "new", "NEW", "Load", "load", "LOAD"];
    end
    
    methods
        function this = Map(varargin)%str,width, length, p_type) % define constructor's Map
            switch nargin
                case 1
                    str = varargin{1};
                    matchedStr = validatestring(str,this.validStrings);
                    this.checkinput(matchedStr);
                    return
                case 3
                    str = varargin{1};
                    validateattributes(varargin{2}, {'double'}, {'positive'});
                    validateattributes(varargin{3}, {'double'}, {'positive'});
                    % if attributes are valid, then continue
                    width  = varargin{2};
                    heigth = varargin{3};
                    matchedStr = validatestring(str,this.validStrings);
                    this.checkinput(matchedStr, width, heigth);
                case 4
                    str = varargin{1};
                    validateattributes(varargin{2}, {'double'}, {'positive'});
                    validateattributes(varargin{3}, {'double'}, {'positive'});
                    validateattributes(varargin{4}, {'double'}, {'positive'});
                    % if attributes are valid, then continue
                    width  = varargin{2};
                    heigth = varargin{3};
                    nrooms = varargin{4};
                    matchedStr = validatestring(str,this.validStrings);
                    this.checkinput(matchedStr, width, heigth, nrooms);
                    % generate map
                    [point, lines, cpoint, cline ]= test(this.width, this.height, this.nrooms);
                    %             cline = cline + max(lines(1,:));
                    temp = [point, cpoint];
                    %             offset = min(temp(temp<0));
                    %             temp(2,:) = temp(2,:) + abs(offset);
                    this.points = temp;
                    this.lines = [lines, cline];
                otherwise
                    mode = struct('WindowStyle','non-modal', 'Interpreter','tex');
                    errordlg('Try to type instead: map("New", width, heigth, n # rooms) or ("Load", file.mat)',...
                        'Error Map generator', mode);
            end 
        end % constructor
    end
    
    methods
        this = plotMap(this, textIndex)
        savemap(this, p_name)
        
    end
    methods (Access = 'private')
        this = setlimit(this)
        checkinput(this, varargin)
        this = setdimension(this, varargin)
        this = setFromFile(this)
    end
    
    methods (Static, Access = 'private')
        [p] = plotLine(initialPoint, finalPoint, lineColor, lineWidth, lineStyle)
    end
end % definition class