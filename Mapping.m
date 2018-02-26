clc
close all
clear

%%

MapName = 'map_square.mat';
mapStuct = load( MapName );

figure(800)
hold on
plotMap(mapStuct.map);
hold off
axis equal
grid on