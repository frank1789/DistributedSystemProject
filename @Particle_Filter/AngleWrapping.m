function angle = AngleWrapping(this, angle)
%ANGLEWRAPPING correct the angle
%
%@param[in] angle - angle passed
%@param[out] angle - corretcted value angle

if(angle > pi)
    angle = angle - 2 * pi;
elseif(angle < -pi)
    angle = angle + 2 * pi;
end
end