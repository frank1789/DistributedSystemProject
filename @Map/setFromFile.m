function this = setFromFile(this)
addpath('presetmap');
d = dir('presetmap/*.mat');
list = {d.name};
[selection] = listdlg('PromptString','Select a file:', ...
                'SelectionMode','single','ListString',list);
 load(list{selection});
 this.points = map.points;
 this.lines = map.lines;
end