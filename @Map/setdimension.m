function this = setdimension(this, varargin)
% setdimension check the argument passed to constructor if are enough to
% build map.
if ~isempty(varargin)
    tmp = varargin{:};
    if (isa(tmp{2}, 'double') && tmp{2} >= 15)
        this.width  = tmp{2};
    else
        h = warndlg('the second (width) argument must be a number >= 15','Warning');
        uiwait(h);
        return
    end
    if (isa(tmp{3}, 'double') && tmp{3} >= 15)
    this.height = tmp{3};
    else
        h = warndlg('the third (height) argument must be a number >= 15','Warning');
        uiwait(h);
        return
    end
    if (isa(tmp{4}, 'double') && tmp{4} >= 1)
    this.nrooms = tmp{4};
    else
        h = warndlg('the fourth (# rooms) argument must be a number >= 1','Warning');
        uiwait(h);
        return
    end
else
    mode = struct('WindowStyle','non-modal', 'Interpreter','tex');
    errordlg('Try to type instead: map("New", width, heigth, # rooms)',...
        'Error Map generator', mode);
end
% clear temporay
clear tmp
end % function