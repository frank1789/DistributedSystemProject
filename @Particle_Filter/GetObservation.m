function [z, iFeature] = GetObservation(this, it)

%fake sensor failure here
if (rand(1) > 0.3)
    z = [];
    iFeature = -1;
    
else
    if (this.Map())
        iFeature = ceil(size(this.Map,2) * rand(1));
        z = this.DoObservationModel(this.xTrue, iFeature) + ...
            sqrt(this.RTrue) * randn(2,1);
        z(2) = this.AngleWrapping(z(2));
    end
    
end