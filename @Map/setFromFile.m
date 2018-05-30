function this = setFromFile(this)
% setFromFile add the folder containing map previous store.
% Cyclic while one map are select from list. 
addpath('presetmap');
d = dir('presetmap/*.mat');
list = {d.name};
while true
    [selection] = listdlg('PromptString','Select a file:', ...
        'SelectionMode','single','ListString',list);
    if selection ~= 0
        map = load(list{selection});
        this.points = map.points;
        this.lines = map.lines;
        break
    else
        h = warndlg('To continue you must select a file','Warning');
        uiwait(h);
    end % if
end % while
end % function