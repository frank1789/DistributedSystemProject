[![License: MIT](https://img.shields.io/badge/license-MIT-blue.svg)](LICENSE)

# Distributed Multirobot Exploration and Mapping

project for final exam

## Installing

Depending on the machine you are using:
- Windows
- Mac
- Linux

First delete files with extensions \*.mex*architecturename*, for example, for Mac the file will have extension: ***.mexmaci64**
you need to compile some mex files before starting: 
- **sens\_model\_.c**
- **potentialfiled.cpp** 
- **mapgen.cpp**

type in terminal:

```Matlab
>> mex -v -output Sens_model_noise sens_model_noise.c
>> mex -v COMPFLAGS='$COMPFLAGS -std=c++14' -output @Map/mapgen ./src/DungeonGenerator/*.cpp
>> mex -v COMPFLAGS='$COMPFLAGS -std=c++14' -output potentialfield ./src/*.cpp
```

Now you can run the script.
If you encounter problems in compiling using the mex command, update Matlab to the latest available release or refer to the [official site](https://mathworks.com/).

## Run
To launch the script, open the *Start.m* file.

### How to use Robot class
```Matlab
% Generating map
% build a new map with map = Map("new", widht, height)
% advice: do not exceed 100 x 100 size
% or load an existing one map = Map("load")
map = Map('load'); 
figure(800); axis equal
map.plotMap();

%% set-up simulation parameters
% Sampling time
MdlInit.Ts = 0.05;
% Length of simulation
MdlInit.T = 25;
time = 0:MdlInit.Ts:MdlInit.T;

%% Vehicle set-up initial conditions
robot = Robot(1, MdlInit.T, MdlInit.Ts, map.getAvailablePoints());
% set 1st target
robot.setpointtarget(map.getAvailablePoints());

%% Perfrom simulation
w = waitbar(0,'Please wait simulation in progress...');
for indextime = 1:1:length(time)
    if mod(indextime,2) == 0 % simualte laserscan @ 10Hz
        robot.scanenvironment(map.points, map.lines, indextime);
    end
    robot.UnicycleKinematicMatlab(indextime);
    robot.ekfslam(indextime);
    
    waitbar(indextime/length(time), w, ...
        sprintf('Please wait simulation in progress... %3.2f%%',...
        indextime/length(time) * 100));
end
close(w); clear w; % delete ui
```


## Authors
- Argentieri Francesco
- Mazzaglia Giacomo
