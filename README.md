[![License: MIT](https://img.shields.io/badge/license-MIT-blue.svg)](LICENSE)

# Distributed Multirobot Exploration and Mapping

Project for the final exam in this paper, we consider the problem of exploring an environment
unknown with a team of robots.
As in the exploration of single robots, the goal is to minimize the
overall exploration time.
The key problem to solve in the context of multiple robots is that of
choose the appropriate destination points for the individual robots so that
can explore different regions of the environment simultaneously. We present
an approach for the coordination of multiple robots, which takes into account simultaneously
of the cost of reaching a target point and its usefulness.
We also describe how our algorithm can be extended to situations
in which the communication range of the robots is limited.
The filter was used to estimate the positions of the robots
particle, assuming a communication with anchors Wi-Fi.
The results show that our technique effectively distributes the robots
on the environment and allows them to fulfill their mission quickly.

## Installing

Depending on the machine you are using:
- Windows
- Mac
- Linux

First delete files with extensions \*.mex*architecturename*, for example, for Mac the file will have extension: ***.mexmaci64**
you need to compile some mex files before starting:
- **sens\_model\_noise.c**
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
To launch the script, open the *Main.m* and press "Run", you can customize the simulation by acting on the parameters as below
```Matlab
% define number of robots to use
numrobot = ;
% define base time
basetime = ;
% increment of time
k = ;
```
For a longer simulation we recommend running the ruby script and following the instructions on the screen
```bash
$ ruby runsimulation.rb
```

Launch script, open the *Demo.m* and press "Run" to view plot and animation.

## Report

The report is available [here](https://github.com/frank1789/DistributedSystemProject/blob/master/Report/Report.pdf) or in the **"Report"** folder.

## How to use

**Main.m**
```Matlab
%% Main - Start multirobot
close all
clear
clc
addpath('Utility-Mapping')
compilemexlibrary
%% Generate Map
% build a new map with:
% map = Map("New", width, heigth);
% map = Map("New", width, heigth, #landmark, "auto");
% map = Map("New", width, heigth, #landmark, "manual");
% or load an existing one:
% map = Map("Load");
% map = Map("Load", #landamark);
% map = Map("Load", #landamark, "auto");
% map = Map("Load", #landamark, "manual");
map = Map('new', 100, 100);
figure('units','normalized','outerposition',[0 0 1 1]); axis equal
axis([0, 100, 0, 100])
map.plotMap();
print('map100x100','-depsc','-r0')
%% Set-up paramaters simulation
% define number of robots to use
numrobot = ;
% define base time
basetime = ;
% increment of time
k = ;

parfor (k = 1:7, 4)
    for n = 1:5
        multirobot(n, k * 150, map, 1)
    end
end
%% analysis result
Result
```
## Use of classes

### Robot class
```Matlab
% set-up simulation parameters
% Sampling time
MdlInit.Ts = 0.05;
% Length of simulation
MdlInit.T = 25;
time = 0:MdlInit.Ts:MdlInit.T;

% Vehicle set-up initial conditions
robot = Robot(1, MdlInit.T, MdlInit.Ts, map.getAvailablePoints());
% set 1st target
robot.setpointtarget(map.getAvailablePoints());

% Perfrom simulation
for indextime = 1:1:length(time)
    if mod(indextime,2) == 0 % simualte laserscan @ 10Hz
        robot.scanenvironment(map.points, map.lines, indextime);
    end
    robot.UnicycleKinematicMatlab(indextime);
end
```

### Map class
```Matlab
% Generate Map
% build a new map with:
% map = Map("New", width, heigth);
% map = Map("New", width, heigth, #landmark, "auto");
% map = Map("New", width, heigth, #landmark, "manual");
% or load an existing one:
% map = Map("Load");
% map = Map("Load", #landamark);
% map = Map("Load", #landamark, "auto");
% map = Map("Load", #landamark, "manual");
% example
map = Map('new', 100, 100);
map.plotMap();
```

### Particle filter class

Within the main cycle after the calculation of the kinematic model insert
```Matlab
if indextime == 1
    pf = Particle_Filter(robot, map.landmark, indextime);
else
    pf{i} = pf{i}.update(robot, indextime);
    robot = robot.setParticleFilterxEst(pf.xEst);
end
```

## Authors
- Argentieri Francesco
- Mazzaglia Giacomo
