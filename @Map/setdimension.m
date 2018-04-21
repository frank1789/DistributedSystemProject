function this = setdimension(this, varargin)
% setdimension check the argument passed to constructor if are enough to
% build map.

if ~isempty(varargin)
    % check second argument
    if (isa(varargin{1}, 'double') && varargin{1} >= 8 && varargin{1} == varargin{2})
        this.width  = varargin{1};
    elseif (isa(varargin{1}, 'double') && varargin{1} >= 8 && varargin{1} ~= varargin{2})
        h = warndlg('the second (width) argument must be euqal third argument (height)','Warning');
        uiwait(h);
        return
    else
        h = warndlg('the second (width) argument must be a number >= 8','Warning');
        uiwait(h);
        return
    end
    
    % check third argument
    if (isa(varargin{2}, 'double') && varargin{2} >= 8 && varargin{2} == varargin{1})
        this.height = varargin{2};
    elseif (isa(varargin{2}, 'double') && varargin{2} >= 8 && varargin{2} ~= varargin{1})
        h = warndlg('the second (width) argument must be euqal third argument (height)','Warning');
        uiwait(h);
        return
    else
        h = warndlg('the third (height) argument must be a number >= 8','Warning');
        uiwait(h);
        return
    end
else
    err = this.error();
    uiwait(err);
end
% clear temporay
clear tmp
end % function