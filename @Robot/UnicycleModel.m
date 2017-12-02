function dy = UnicycleModel(this, t, y, piterator)

% Input parser
xu = y(1);
yu = y(2);
thetau = y(3);
% theta_t = 0;
% mindistance = 0.85;
if ~isempty(this.distance{piterator})
    this.mindistance = min(this.distance{piterator});
    fprintf('check distance: %f\n', this.mindistance);
%     tic
% %       for k = 251:length(this.test)
%         i_lower  = find(isnan(this.test(1,:)) <= this.test(1,:),251,'last');
%         
%         i_higher = find(isnan(this.test(1,:)) >= this.test(1,:),251,'first');
% %       end
%         if ~isempty(i_higher) || ~isempty(i_lower)
%             disp(i_higher);
%             disp(i_lower);
%         end
%        toc
% end
    for kk = 1:1:floor(length(this.test)/2)
        if(isnan(this.test(251-kk)))
%             theta_t = this.laserTheta(ii);
           break
        end
    end
    
    for jj = 251:1:length(this.test)
        if(isnan(this.test(jj)))
%            theta_t = this.laserTheta(jj);
           break
        end
    end
    
    if jj-250>kk
        this.theta_t = this.laserTheta(kk);
    else
       this.theta_t = this.laserTheta(jj);
    end
    
end    

% this.theta_t = theta_t;
% thetau = theta_t;



[v, omega] = this.UnicycleInputs(t, this.mindistance, this.theta_t);





% System kinematic
xu_d = cos(thetau) * v;
yu_d = sin(thetau) * v;
thetau_d = omega;

% Output
dy = [xu_d; yu_d; thetau_d];
end % method