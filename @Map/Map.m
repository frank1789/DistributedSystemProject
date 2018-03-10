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
        nrooms; % max number of rooms can be generated
        points = []; % store points of plant
        lines  = []; % store lines of plant
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
                case 4
                    str = varargin{1};
                    matchedStr = validatestring(str,this.validStrings);
                    this.checkinput(matchedStr, varargin);
                    % generate map
                    if(~isempty(this.width) && ~isempty(this.height) && ~isempty(this.nrooms))
                        [point, lines, cpoint, cline ]= test(this.width, this.height, this.nrooms);
                    
                    %             cline = cline + max(lines(1,:));
                    temp = [point, cpoint];
                    %             offset = min(temp(temp<0));
                    %             temp(2,:) = temp(2,:) + abs(offset);
                    this.points = temp;
                    this.lines = [lines, cline];
                    end % if
                otherwise
                    mode = struct('WindowStyle','non-modal', 'Interpreter','tex');
                    errordlg({'Try to type instead: map("New", width, heigth, # rooms) or map("Load")'},...
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