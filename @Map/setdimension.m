function this = setdimension(this, varargin)
% setdimension check the argument passed to constructor if are enough to
% build map.
tmp = varargin{:};
validateattributes(tmp{2}, {'double'}, {'positive'});
validateattributes(tmp{3}, {'double'}, {'positive',});
validateattributes(tmp{4}, {'double'}, {'positive','>=' 1});
% if attribute are satisied continue
this.width  = tmp{2};
this.height = tmp{3};
this.nrooms = tmp{4};
% clear temporay 
clear tmp
end % function