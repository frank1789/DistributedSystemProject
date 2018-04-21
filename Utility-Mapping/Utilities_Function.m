function [ P ] = Utilities_Function( robot,idx_robot,n,max_range)
%UTILITIES_FUNCTION Summary of this function goes here
%   Detailed explanation goes here

  
    P=0;
    
    for i=1:1:n
        if(idx_robot~=i)
        d = norm(robot{idx_robot}.target(1:2) - robot{i}.target(1:2));
            
            if(d<max_range)
                Pd = 1 - d/max_range;
            else
                Pd = 0;
            end
    
         P = P + Pd;
        end
  
    end
        
end
