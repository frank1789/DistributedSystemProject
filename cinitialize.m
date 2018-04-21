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

theta = Robot.laserTheta;
ris = resolution;
r0= Robot.mindistance / ris;

y = r0 * sin(theta);
x = r0 * cos(theta);

x_g = floor(x);
y_g = floor(y);

max_x = max(x_g);
max_y = max(y_g);

n_mis = length(time);

occ_mat = zeros(max_x, 2 * max_y);
lid_mat = zeros(max_x, 2 * max_y);

room_length = max(Map.points(1,:));
room_width  = max(Map.points(1,:));

lgth =  floor(room_length / ris);
wdth =  floor(room_width / ris);

Cost_map = zeros(lgth, wdth);

center_x = floor(lgth / 2);
center_y = floor(wdth / 2);


%return data initiliazized for occupacy grid
initializedata = struct('theta', theta, ...
    'ris', resolution, ...
    'r0', r0, ...
    'y', x, ...
    'x', y, ...
    'x_g', x_g, ...
    'y_g', y_g, ...
    'max_x', max_x, ...
    'max_y', max_y, ...
    'n_mis', n_mis, ...
    'occ_mat', occ_mat, ...
    'lid_mat', lid_mat, ...
    'room_length', room_length, ...
    'room_width', room_width, ...
    'lgth', lgth, ...
    'wdth', wdth, ...
    'Cost_map', Cost_map, ...
    'center_x', center_x, ...
    'center_y', center_y);
end