function b = drawscan(Robot, Particle_Filter, it)
b = [];
if ~isempty(Robot.laserScan_xy{it})
    % compute the laserscan in word frame
    R = Robot.rotationMatrix(Particle_Filter.xEst(it,3)); % apply rotation matrix
    % global frame
    b = (Robot.getRawlaserScan(it)' / R + [Particle_Filter.xEst(it,1); Particle_Filter.xEst(it,2)]')';
end