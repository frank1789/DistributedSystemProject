clc
close all
clear

%%
% mex -output test  src/*.cpp

%%
% a = Map();
 a = Map("Load");
a.plotMap;
% MapName = 'map_square.mat';
% mapStuct = load( MapName );
% 
% figure(800)
% hold on
% plotMap(mapStuct.map);
% hold off
% axis equal
% grid on

