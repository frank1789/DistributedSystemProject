function numsteps = getEKFstep(this)
%GETEKFSTEP method that access the property EKF_NumS
% INPUT:
%  this = refer to this object
% OUTPUT:
%     numsteps (int) = number of tseps computed by Kalman filter
numsteps = this.EKF_NumS;
end