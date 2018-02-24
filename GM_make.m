             laserScan_xy{ii} = robot{rr}.laserScan_2_xy(ii);
    
             if(isempty(laserScan_xy{1,ii}{1,1}) || all((all(isnan(laserScan_xy{1,ii}{1,1})))==1))
    
             else
                 out = laserScan_xy{1,ii}{1,1}(:,all(~isnan(laserScan_xy{1,ii}{1,1})));
                 [ occ_mat(:,:)] = Occ_Grid( occ_mat(:,:),lid_mat(:,:),out);
               
                  for i = 1:1:length(occ_mat(:,1))
                            for j = 1:1:length(occ_mat(1,:))
                                      if mod(ii,40)==0
                                    
                                         %  Compute Cost matrix
                                         A     = [cos(robot{rr}.q(ii,3)), -sin(robot{rr}.q(ii,3)), robot{rr}.q(ii,1)/ris; 
                                                  sin(robot{rr}.q(ii,3)),  cos(robot{rr}.q(ii,3)), robot{rr}.q(ii,2)/ris;  
                                                    0                 0             1]*[i ;(length(occ_mat(1,:)))/2+1-j; 1]; 
                                            A=floor(A);
                                            if(A(2)>wdt || A(2)==wdt)
                                            A(2) = wdt-1; 
                                            end
                                            if(A(2)==0 || A(2)<0)
                                                A(2)=1;
                                            end
                                            if(A(1)==0 || A(1)<0)
                                                A(1)=1;
                                            end
                                            if(A(1)>lgth)
                                            A(1) = lgth; 
                                            end
                                            CC=[A(2),A(1)];
                                            Cost_map(wdt-CC(1),CC(2),rr)= 5;%min(10,Cost_map(wdt-CC(1),CC(2)) +10/(i^2+j^2-2)^0.25);
                                            
                                            %Reset Target Location

                                                                       
                                                  y=0.15*r0*sin(theta+robot{rr}.q(ii,3))+robot{rr}.q(ii,2);
                                                  x=0.15*r0*cos(theta+robot{rr}.q(ii,3))+robot{rr}.q(ii,1); 
                                                  front = [x;y];
                                          
                                                 for ll = 1:1:250
                                                    if(isnan(robot{rr}.laserScan_2_xy{1,ii}(1,251-ll)) && front(1,251-ll)>0 && front(2,251-ll)>0)
                                                      robot{rr}.setpointtarget([front(1,251-ll) front(2,251-ll) 0]);
                                                                break
                                                         else if(isnan(robot{rr}.laserScan_2_xy{1,ii}(1,251+ll))&& front(1,251+ll)>0 && front(2,251+ll)>0)
                                                                 robot{rr}.setpointtarget([front(1,251+ll) front(2,251+ll) 0]);
                                                                 break
                                                              end
                                                    end
                                                 end
                                                
                                                 if mod(ii,160)==0
                                                  [raw,column] = minmat(Cost_map(:,:,rr));
                                                  new_target =[ceil(column*0.15);ceil(17-raw*0.15);1];
                                                  robot{rr}.setpointtarget([new_target(1) new_target(2) 0]);
                                                  end
                              end
                                if(occ_mat(i,j)~=0)
                                         A     = [cos(robot{rr}.q(ii,3)), -sin(robot{rr}.q(ii,3)), robot{rr}.q(ii,1)/0.015; 
                                                  sin(robot{rr}.q(ii,3)),  cos(robot{rr}.q(ii,3)), robot{rr}.q(ii,2)/0.015;  
                                                    0                 0             1]*[i ;267-j; 1]; 
                                            A=floor(A);
                                            if(A(2)>wdt || A(2)==wdt)
                                            A(2) = wdt-1; 
                                            end
                                            if(A(2)==0 || A(2)<0)
                                                A(2)=1;
                                            end
                                            if(A(1)==0 || A(1)<0)
                                                A(1)=1;
                                            end
                                            if(A(1)>lgth)
                                            A(1) = lgth; 
                                            end
                                            CC=[A(2),A(1)];
                                            if(Global_map(wdt-CC(1),CC(2),rr)==0) 
                                            Global_map(wdt-CC(1),CC(2),rr)= occ_mat(i,j); 
                                            else
                                            Global_map(wdt-CC(1),CC(2),rr)= (occ_mat(i,j) + Global_map(wdt-CC(1),CC(2),rr))/2; 
                                            end
                                end
                            end
                   end
                 
                 
             end
             
            
            