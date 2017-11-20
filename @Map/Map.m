classdef Map < handle
    properties %(Access = 'private')
        occupacygrid = [];
        V_xy =[];
        namemap;
    end
    methods
        setoccupacygrid(this, image);
        computecostfunc(this, initialposition);
    end
end % definition class