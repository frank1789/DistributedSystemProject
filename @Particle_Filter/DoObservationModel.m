function z = DoObservationModel(this, xVeh, iFeature)
%GETOBSERVATION  return model of observator
%
%@param[in] xVeh - true position
%@param[in] iFeature - selected landmark
%@param[out] z - observation

Delta = this.Map(1:2, iFeature) - xVeh(1:2);
z = [norm(Delta); atan2(Delta(2), Delta(1)) - xVeh(3)];          
z(2) = this.AngleWrapping(z(2));
end