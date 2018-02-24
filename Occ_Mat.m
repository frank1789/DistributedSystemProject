function [ occ_mat,kk ] = Occ_Mat( occ_mat,lid_mat,laserScan_xy,ii,kk)
%OCC_MAT Summary of this function goes here
%   Detailed explanation goes here

 %laserScan_xy{ii} = laserScan_2_xy(ii);
    
             if(isempty(laserScan_xy{1,ii}{1,1}) || all((all(isnan(laserScan_xy{1,ii}{1,1})))==1))
    
             else
                 out = laserScan_xy{1,ii}{1,1}(:,all(~isnan(laserScan_xy{1,ii}{1,1})));
                 [ occ_mat(:,:,kk)] = Occ_Grid( occ_mat(:,:,kk),lid_mat(:,:,kk),out);
                 kk=kk+1;
             end
             
end

