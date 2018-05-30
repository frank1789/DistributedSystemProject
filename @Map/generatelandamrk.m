function this = generatelandamrk(this, varargin)
%GENERATELANDMARK pose landamrk for particle filter in random position or
%selected by user.
%
%@param[in] varargin{1} - number of landmark to generate
%@param[in] varargin{2} - mode 'auto' or 'manual'

% point valid for selection area
pointmax = max(this.points(1,:));
pointmin = min(this.points(1,:));

switch nargin
    case 2
        this.landmark = (1 + max(this.points(1,:)) - 1) * rand(2, varargin{1}); % pose landamrk for particle filter
    case 3
        if varargin{2} == 'manual'
            for i = 1:varargin{1}
                figure(1); hold on;
                this.plotMap();
                help = msgbox({sprintf('Place the reference points.\n To be positioned: %2i', (varargin{1} - i + 1)), ...
                    'click with the left mouse button'}, 'Select point','help');
                uiwait(help);
                [x,y] = ginput(1);
                if x > pointmin && x < pointmax && y > pointmin && y < pointmax
                    plot(x,y,'r+');
                    this.landmark(:,i) = [x y 0]';
                else
                    err = errordlg('Invalid selection','Error');
                    uiwait(err);
                end % if
            end
        end
    otherwise
        disp('No value specified for the number of landmarks to be placed, use the default value (# 30)');
        this.landmark = (1 + max(this.points(1,:)) - 1) * rand(2, 30); % pose landamrk for particle filter
end
close(figure(1));
end