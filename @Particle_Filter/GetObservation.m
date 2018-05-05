function [z, iFeature] = GetObservation(this)
%GETOBSERVATION  model of observator
%
%@param[in] lentime - length of time simulazion (length(start:sample:stop))
%@param[in] it - index of cycle silmulation

%fake sensor failure here
if rand(1) > 0.95
    z = [];
    iFeature = -1;
else
    if (this.Map())
        iFeature = ceil(size(this.Map, 2) * rand(1));
        z = this.DoObservationModel(this.xTrue, iFeature) + ...
            sqrt(this.RTrue) * randn(2,1);
        z(2) = this.AngleWrapping(z(2));
    end
end