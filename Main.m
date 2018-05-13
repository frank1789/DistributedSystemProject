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
map = Map('new',40,40);
%0figure(801); axis equal
%map.plotMap();


for i=1
    for n=4
        for k=3
         multirobot(n,600+k*300,map,i)
        end
    end
end

    loadFile = sprintf('n_robot_%i_Sim_time_%i_attempt_num_%i.mat',n_robot(j),Simulation_time(i),i)