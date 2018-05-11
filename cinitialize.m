function [ initializedata ] = cinitialize(Robot, Map, time, resolution)
%CINITILIZE  initialize data struct for compute occupacy grid
%
%@param[in] Robot - Robot class
%@param[in] Map - Map class
%@param[in] time - length of simulation
%@param[in] resolution - specify the resolution of map
%@param[out] initializedata - struct contains data ready to use

validateattributes(Robot,{'Robot'},{'nonempty'})
validateattributes(Map,{'Map'},{'nonempty'})
validateattributes(time,{'numeric'},{'nonnegative'})
validateattributes(resolution,{'numeric'},{'nonnegative'})

%%Simulation parameters initialization

beta       = 90;     %half of the lidar span angle
beta_cost  = 1;      %constant of cost function
Max_Occ    = 0.8;    %Maximum probability of occupied cell due to occlusion
Min_Occ    = 0.2;    %Minimum probability of free cell less that this value the cell is free

Max_com = 16;        %Maximum communication range

%%Preallocation of usefull 
theta = Robot.laserTheta;
ris = resolution;
r0= Robot.lasermaxdistance / ris;

y = r0 * sin(theta);
x = r0 * cos(theta);

x_g = floor(x);
y_g = floor(y);

comunication = 0;
delay = 0;
it_needed = 0;
already_visit = 0;

max_x = max(x_g);
max_y = max(y_g);

n_mis = length(time);

occ_mat = zeros(max_x, 2 * max_y);
lid_mat = zeros(max_x, 2 * max_y);

room_length = max(Map.points(1,:));
room_width  = max(Map.points(1,:));

lgth =  floor(room_length / ris);
wdth =  floor(room_width / ris);

Cost_map = zeros(lgth, wdth) + 0.5;

center_x = floor(lgth / 2);
center_y = floor(wdth / 2);






%return data initiliazized for occupacy grid
initializedata = struct('theta', theta, ...
    'ris', resolution, ...
    'beta',beta,...
    'beta_cost',beta_cost,...
    'Max_Occ',Max_Occ,...
    'Min_Occ',Min_Occ,...
    'Max_com',Max_com,...
    'r0', r0, ...
    'y', x, ...
    'x', y, ...
    'x_g', x_g, ...
    'y_g', y_g, ...
    'max_x', max_x, ...
    'max_y', max_y, ...
    'n_mis', n_mis, ...
    'occ_mat', occ_mat, ...
    'comunication',comunication, ...
    'already_visit',already_visit,...
    'delay',delay, ...
    'it_needed',it_needed,...
    'lid_mat', lid_mat, ...
    'room_length', room_length, ...
    'room_width', room_width, ...
    'lgth', lgth, ...
    'wdth', wdth, ...
    'Cost_map', Cost_map, ...
    'center_x', center_x, ...
    'center_y', center_y);

clear Robot Map time resolution
end