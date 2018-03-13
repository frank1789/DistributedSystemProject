
theta=-pi/2:0.36*pi/180:pi/2;
ris = 0.15;
r0=4/ris;

y=r0*sin(theta);
x=r0*cos(theta);

x_g=floor(x);
y_g=floor(y);

max_x = max(x_g);
max_y = max(y_g);

n_mis = 1000;%length(laserScan_xy);

occ_mat = zeros(max_x,2*max_y);
lid_mat = zeros(max_x,2*max_y);

room_length = 49;
room_width  = 49;

lgth =  floor(room_length/ris);
wdt  =  floor(room_width/ris);

Global_map = zeros(lgth,wdt,3);
Cost_map = zeros(lgth-1,wdt-1,3);

center_x = floor(lgth/2);
center_y = floor(wdt/2);

laserScan_xy = cell.empty;
j=1;
kk=1;