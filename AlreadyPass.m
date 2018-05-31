function [already_pass] = AlreadyPass(q_prec,q_act)
%ALREADYPASS Summary of this function goes here
%   Detailed explanation goes here

Max_passage   = 2;   % Maximum number of tollereted passage on already visited points
Times_passed  = 0;   % Count parameter for passage times
already_pass  = 0;   % Boolean variable to identify if Maximum number of passage was overcome
Range_passage = 0.25; % Range 

 for i =1:length(q_prec)-290
     
 if(find(norm(q_prec(i,:) - q_act)< Range_passage))
     Times_passed = Times_passed +1;
 end
 
      if (Times_passed == Max_passage)
          already_pass = 1;
     break
     end
 
 end
end

