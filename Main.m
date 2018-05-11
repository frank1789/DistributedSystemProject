%% Main - Start multirobot
close all
clear
clc
addpath('Utility-Mapping')

%% Generating map
% build a new map with:
% map = Map("New", width, heigth);
% map = Map("New", width, heigth, #landmark, "auto");
% map = Map("New", width, heigth, #landmark, "manual");
% or load an existing one:
% map = Map("Load");
% map = Map("Load", #landamark);
% map = Map("Load", #landamark, "auto");
% map = Map("Load", #landamark, "manual");
map = Map('new',40,40);
%0figure(801); axis equal
%map.plotMap();

for n=1:4

multirobot(n,100,map)
end