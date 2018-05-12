A = occparameters{1}.Cost_map;
B = map.data;

C = resizem(A,[40 40],'bicubic');

correct = 0;

for i=1:length(B)
    for j=1:length(B)
        
        switch(C(i,j))
            
            case 0
                if(B(i,j)==0)
                     correct = correct + 1;
                else
                     
                end

            case 0.5
                if(B(i,j)==0)
                    
                else
                  correct = correct + 1;
                end
                
            case 1
                if(B(i,j)==0)
                    
                else
                    correct = correct + 1;
                end
            
        end
        
    end
end


A = occparameters{1}.Cost_map;
B = map.data;
C = resizem(A,[40 40],'bicubic');
(length(find(C>0.6))/length(map.available))*100