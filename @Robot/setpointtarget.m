function this = setpointtarget(this, ppoint)
validateattributes(ppoint(1:2),{'numeric'},{'nonnegative'});
if length(ppoint) == 3
    this.target = ppoint;
else
    this.target = [ppoint 0];
end
end