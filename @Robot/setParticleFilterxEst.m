function this = setParticleFilterxEst(this, xEstimated)
%SETPARTICLEFILTERXEST store in memory of robot the position estimated by
%pf.
% @param[in] xEstimated: vector of position estimated
this.pf_xEst = xEstimated;
end