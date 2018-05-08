classdef Map
    % MAPCLASS  allows procedural creation of a map or loads an existing one
    % from a file stroed in 'presetmap'.
    %
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
    %
    %
    %   MAP properties:
    %       width;  - max width of map
    %       height - max height of map
    %       points  -  store points of plant
    %       lines   - store lines of plant
    %       available -  explorable points
    %       landmark -  set the refernce point in map (aka Landmark) for particle filter
    %
    %    MAP methods:
    %       Map - default constructor to generate a map.
    %       plotMap - draw the map
    %       getAvailablePoints - return point available for robot
    %       savemap - store maps in file *.mat
    
    properties (SetAccess = 'private')
        width;  % max width of map
        height; % max height of map
        points = []; % store points of plant
        lines  = []; % store lines of plant
        available = []; % explorable points
        landmark = []; % set the refernce point in map (aka Landmark) for particle filter
    end
    
    properties (Constant, Access = 'private')
        validStrings = ["New", "new", "NEW", "Load", "load", "LOAD"]; % possible inputs
        mode = ["auto", "manual"];
    end
    
    methods
        function this = Map(varargin)
            % MAP default constructor to generate a map.
            %
            % if first param is a string equal 'load' to one of those expressed
            % previously, it allows to load an existing map from file.
            % if 4 input parameters are supplied preceded by 'new', it
            % generates a new map.
            %
            %@param[in] varargin{1} - string must be equal "New", "new", "NEW", "Load", "load", "LOAD"
            %@param[in] varargin{2} - width
            %@param[in] varargin{3} - heigth
            %@param[in] varargin{4} - number of landmark
            %@param[in] varargin{5} - "auto" or "manual" positioning
            %landamark.
            
            switch nargin
                case 1
                    % parse varargin
                    str = varargin{1};
                    matchedStr = validatestring(str,this.validStrings);
                    this = this.checkinput(matchedStr);
                    this = this.generatelandamrk();
                case 2
                    % parse varargin
                    str = varargin{1};
                    matchedStr = validatestring(str,this.validStrings);
                    this = this.checkinput(matchedStr);
                    validateattributes(varargin{2},{'numeric'},{'>=',10,'<=',65});
                    numland = varargin{2};
                    this = this.generatelandamrk(numland);
                case 3
                    str = varargin{1};
                    matchedStr = validatestring(str,this.validStrings);
                    if (matchedStr == "Load" || matchedStr == "load" || matchedStr == "LOAD")
                        this = this.checkinput(matchedStr);
                        validateattributes(varargin{2},{'numeric'},{'>=',10,'<=',65});
                        numland = varargin{2};
                        mode = validatestring(varargin{3},this.mode);
                        if mode == "manual" && numland == 10
                            this = this.generatelandamrk(numland, mode);
                        else
                            this = this.generatelandamrk(numland);
                        end
                    elseif (matchedStr == "New" || matchedStr == "new" || matchedStr == "NEW") && ...
                            (isa(varargin{2}, 'double') && isa(varargin{3}, 'double'))
                        this = this.checkinput(matchedStr, varargin{2:3});
                        this = this.generatelandamrk();
                    else
                        err  = this.error();
                        uiwait(err);
                    end
                case 4
                    % parse varargin
                    str = varargin{1};
                    matchedStr = validatestring(str,this.validStrings);
                    if (matchedStr == "New" || matchedStr == "new" || matchedStr == "NEW") && ...
                            (isa(varargin{2}, 'double') && isa(varargin{3}, 'double'))
                        this = this.checkinput(matchedStr, varargin{2:3});
                        validateattributes(varargin{4},{'numeric'},{'>=',10,'<=',65});
                        numland = varargin{4};
                        this = this.generatelandamrk(numland);
                    else
                        err  = this.error();
                        uiwait(err);
                    end
                case 5
                    % parse varargin
                    str = varargin{1};
                    matchedStr = validatestring(str,this.validStrings);
                    if (matchedStr == "New" || matchedStr == "new" || matchedStr == "NEW") && ...
                            (isa(varargin{2}, 'double') && isa(varargin{3}, 'double'))
                        this = this.checkinput(matchedStr, varargin{2:3});
                        validateattributes(varargin{4},{'numeric'},{'>=',10,'<=',65});
                        numland = varargin{4};
                        validateattributes(numland,{'numeric'},{'>=',10,'<=',65});
                        mode = validatestring(varargin{5},this.mode);
                        if mode == "manual" && numland == 10
                            this = this.generatelandamrk(numland, mode);
                        else
                            fprintf("if the number of landmarks is greater than 10, the manual positioning mode is ignored\n");
                            this = this.generatelandamrk(numland);
                        end
                    else
                        err  = this.error();
                        uiwait(err);
                    end
                otherwise
                    err  = this.error();
                    uiwait(err);
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
        this = checkinput(str, varargin)
        this = setdimension(this, varargin)
        this = setFromFile(this)
        this = setpoints(this, data)
        this = setAvailablePoints(this, input)
        this = generatelandamrk(this, varargin)
    end
    
    methods (Static, Access = 'private')
        [p] = plotLine(initialPoint, finalPoint, lineColor, lineWidth, lineStyle)
        [data] = mapgen(width, height)
        [ err ] = error()
        [vsegment] = setverticalsegment(input)
        [hsegment] = sethorizontalsegment(input)
    end
end % definition class