function b = drawscan(Robot, Particle_Filter, it)
b = [];
if ~isempty(Robot.laserScan_xy{it})
    % compute the laserscan in word frame
    R = Robot.rotationMatrix(Robot.q(it,3)); % apply rotation matrix
    % global frame
    b = (Robot.getRawlaserScan(it)' / R + [Robot.q(it,1); Robot.q(it,2)]')';
end