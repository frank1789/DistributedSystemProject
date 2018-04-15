function [z,iFeature] = GetObservation(k)

global Map;
global xTrue;
global RTrue;
global nSteps;


%fake sensor failure here
if (rand(1) > 0.3)
z = [];
iFeature = -1;

else
if (Map())
iFeature = ceil(size(Map,2)*rand(1));
z = DoObservationModel(xTrue, iFeature,Map)+sqrt(RTrue)*randn(2,1);
z(2) = AngleWrapping(z(2));
end;

end