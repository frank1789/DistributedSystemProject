function numsteps = getEKFstep(this)
%GETEKFSTEP method that access the property EKF_NumS
% @param [out]  numsteps = number of tseps computed by Kalman filter
numsteps = this.EKF_NumS;
end %method
