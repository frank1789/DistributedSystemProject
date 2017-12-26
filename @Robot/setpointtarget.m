function this = setpointtarget(this, ppoint)
% validateattributes(ppoint,{'numeric'},{'nonnegative'});
if length(ppoint) == 3
    this.target = ppoint;
else
    this.target = [ppoint 0];
end
end