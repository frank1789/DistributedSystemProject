function this = setdimension(this, varargin)
% setdimension check the argument passed to constructor if are enough to
% build map.
if ~isempty(varargin)
    tmp = varargin{:};
    validateattributes(tmp{2}, {'double'}, {'positive','>=' 15});
    validateattributes(tmp{3}, {'double'}, {'positive','>=' 15});
    validateattributes(tmp{4}, {'double'}, {'positive','>=' 1});
    % if attribute are satisied continue
    this.width  = tmp{2};
    this.height = tmp{3};
    this.nrooms = tmp{4};
else
    mode = struct('WindowStyle','non-modal', 'Interpreter','tex');
    errordlg('Try to type instead: map("New", width, heigth, # rooms)',...
        'Error Map generator', mode);
end
% clear temporay
clear tmp
end % function