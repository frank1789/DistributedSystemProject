function this = setdimension(this, varargin)
% setdimension check the argument passed to constructor if are enough to
% build map.

if ~isempty(varargin)
    tmp = varargin{:};
    % check second argument
    if (isa(tmp{2}, 'double') && tmp{2} >= 8 && tmp{2} == tmp{3})
        this.width  = tmp{2};
    elseif (isa(tmp{2}, 'double') && tmp{2} >= 8 && tmp{2} ~= tmp{3})
        h = warndlg('the second (width) argument must be euqal third argument (height)','Warning');
        uiwait(h);
        return
    else
        h = warndlg('the second (width) argument must be a number >= 8','Warning');
        uiwait(h);
        return
    end
    
    % check third argument
    if (isa(tmp{3}, 'double') && tmp{3} >= 8 && tmp{3} == tmp{2})
        this.height = tmp{3};
    elseif (isa(tmp{3}, 'double') && tmp{3} >= 8 && tmp{3} ~= tmp{2})
        h = warndlg('the second (width) argument must be euqal third argument (height)','Warning');
        uiwait(h);
        return
    else
        h = warndlg('the third (height) argument must be a number >= 8','Warning');
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