function this = store(this, i)
% STORE method to achive the estmation of EKF
% INPUT:
%  this = refer to this object
%  i = iterator from cycle
% OUTPUT: none
    this.EKF_q_store(:,i) = this.EKF_q_est;
end
