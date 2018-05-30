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
