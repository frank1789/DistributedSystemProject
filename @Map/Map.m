classdef Map < handle
    properties %(Access = 'private')
        width;
        length;
        points = [];
        lines = [];
        z;
    end
    
    properties (Constant, Access = 'private')
        validStrings = ["Simple", "Fixed", "Random"];
    end
    
    methods
        function this = Map(width, length, p_type) % define constructor's Map
            % check input
            validateattributes(width, {'double'}, {'positive'});
            validateattributes(length, {'double'}, {'positive'});
%             validType = validatestring(p_type, this.validStrings);
            % if all inputs are correct continue
            this.width = width;
            this.length = length;
            [z ]= test(width, length, p_type)
            this.z = z;
%             switch validType
%                 case 'Simple'
%                     this.setlimit();
%                 case 'Fixed'
%                     disp('Not working')
%                 case 'Random'
%                     disp('Not working')
%             end
        end % constructor
    end
    
    methods
        this = plotMap(mapStructure , textIndex)
        savemap(this, p_name)
        
    end
    methods (Access = 'private')
        this = setlimit(this)
    end
    
    methods (Static, Access = 'private')
        [p] = plotLine(initialPoint, finalPoint, lineColor, lineWidth, lineStyle)
    end
end % definition class