function this = setdimension(this, varargin)
switch nargin
    case 2
         errordlg('Specifies height and number of rooms to be generated','Eroor');
    case 3
        warndlg('Specifies the number of rooms to be generated','Error');
    case 4
        this.width  = varargin{1};
        this.height = varargin{2};
        this.nrooms = varargin{3};
    otherwise
        errordlg('Specifies all data: map("New", width, heigth, n # rooms)','Eroor');
end
end % function