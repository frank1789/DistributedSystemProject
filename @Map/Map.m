classdef Map < handle
    % MapClass allows procedural creation of a map or loads an existing one
    % from a file stroed in 'presetmap'.
    % To create a new Map object, type for example:
    % - map = Map("New", x, y, z) to launch the creation a new map of
    %   specified dimensions and a maximum number of rooms to the data
    %   specified as the fourth argument
    % - map = Map("Load") starts a ui from which you can load a saved
    %   previous map.
    % To view the created map, for example, 'map.plotMap();'.
    % All class attributes are private in writing, therefore not accessible
    % from outside the class, on the contrary they can be accessed only in
    % read mode.
    % To pass arguments to the function, type 'map.points' and 'map.lines'.
    properties (SetAccess = 'private')
        width;  % max width of map
        height; % max height of map
        points = []; % store points of plant
        lines  = []; % store lines of plant
        available = []; % explorable points
    end
    
    properties (Constant, Access = 'private')
        validStrings = ["New", "new", "NEW", "Load", "load", "LOAD"]; % possible inputs
    end
    
    methods
        function this = Map(varargin)
            % MAP default constructor to generate a map.
            % @param[in] string must be equal "New", "new", "NEW", "Load", "load", "LOAD"
            % @param[in] numeric width
            % @param[in] numeric heigth
            % @param[in] numeric number of room
            % if first param is a string equal 'load' to one of those expressed
            % previously, it allows to load an existing map from file.
            % if 4 input parameters are supplied preceded by 'new', it
            % generates a new map.
            switch nargin
                case 1
                    str = varargin{1};
                    matchedStr = validatestring(str,this.validStrings);
                    this.checkinput(matchedStr);
                case 3
                    str = varargin{1};
                    matchedStr = validatestring(str,this.validStrings);
                    this.checkinput(matchedStr, varargin);
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
                otherwise
                    mode = struct('WindowStyle','non-modal', 'Interpreter','tex');
                    errordlg({'Try to type instead: map("New", width, heigth) or map("Load")'},...
                        'Error Map generator', mode);
            end
        end % constructor
    end
    
    methods
        this = plotMap(this, textIndex)
        point = getAvailablePoints(this)
        savemap(this, p_name)
    end
    methods (Access = 'private')
        this = setlimit(this)
        checkinput(this, varargin)
        this = setdimension(this, varargin)
        this = setFromFile(this)
        [vsegment] = setverticalsegment(this, input)
        [hsegment] = sethorizontalsegment(this, input)
        this = setpoints(this, data)
        this = setAvailablePoints(this, input)
    end
    
    methods (Static, Access = 'private')
        [p] = plotLine(initialPoint, finalPoint, lineColor, lineWidth, lineStyle)
        [data] = mapgen(width, height);
        
    end
end % definition class