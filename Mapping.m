clc
close all
clear

%%
% mex -output test  src/*.cpp

%%
a = Map(80, 100, 7);
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

