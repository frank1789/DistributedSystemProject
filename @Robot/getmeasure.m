function this = getmeasure(this, t)

persistent n m;


 
    laserScan_xy = this.getlaserscan(t); 
    [n, m]= size(laserScan_xy);
    if ~isempty(laserScan_xy) 
        distance = sqrt(laserScan_xy(1,:).^2 + laserScan_xy(2,:).^2);
    else
        distance = nan(1,m);
    end 
 
this.distance{t} = distance; 
% disp(distance);
end 