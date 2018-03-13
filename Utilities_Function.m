function [ P ] = Utilities_Function( t_glob,idx_robot,n,max_range)
%UTILITIES_FUNCTION Summary of this function goes here
%   Detailed explanation goes here

    t_glob_n = t_glob(:,idx_robot);
    t_glob(:,idx_robot) = [];
    n=n-1;
    P=0;
    
    for i=1:1:n
        d = norm(t_glob_n-t_glob(:,i));
    if(d<max_range)
        Pd = 1 - d/max_range;
    else
        Pd = 0;
    end
    
    P = P + Pd;
    end
  
end