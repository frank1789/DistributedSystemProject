function [ occ_mat] = Occ_Grid(occparameters,a )
%OCC_GRID Summary of this function goes here
%This function build a local occupacy grid for the robot for the actual
%scan at iteration ii
%The formalution can be seen on the article "IMPLEMENTATION OF AUTONOMOUS 
%NAVIGATION AND MAPPING USING A LASER LINE SCANNER ON A TACTICAL UNMANNED
%AERIAL VEHICLE"


%Parameter initialization
 occ_mat = occparameters.occ_mat; 
 lid_mat = occparameters.lid_mat;
 ris     = occparameters.ris;
 R       = occparameters.r0;
 
beta     =  occparameters.beta*(pi/180);
Max_Occ  =  occparameters.Max_Occ;

%Robot position rispect matrix indices
x_0 = 1;%floor(length(sub_occ_matr(1,:))/2);
y_0 = floor(length(occ_mat(1,:))/2);%x_0;

%wall position captured by lidar
b=[floor(a(1,:)/ris);y_0+1-floor(a(2,:)/ris)]+1;

%occ_matrices before applying the formula given by the article
for i=1:1:length(a(1,:))
   lid_mat(b(1,i),b(2,i))=1;
end

%Calculute the local occupation matrix for the robot at iteration ii 

%Primo Quadrante
for i = x_0 : 1 : length(occ_mat(:,1))
    for j = y_0 : 1 : length(occ_mat(1,:))
        
        if(lid_mat(i,j)~=0)
        alpha = atan((y_0-j)/i);
        r     = sqrt(i^2+(y_0-j)^2);
   
        occ_mat(i,j) =  -(((R-r)/(R)+(beta- abs(alpha)))/2)*Max_Occ*lid_mat(i,j);
        end
    end
end

%Secondo Quadrante
for i = x_0 : 1 : length(occ_mat(:,1))
    for j = y_0 : -1 : 1

        if(lid_mat(i,j)~=0)
        alpha = atan((y_0-j)/i);
        r     = sqrt(i^2+(y_0-j)^2);
   
        occ_mat(i,j) =  -(((R-r)/(R)+(beta-abs(alpha)))/2)*Max_Occ*lid_mat(i,j);
        end
     end
end

% figure
% mesh(lid_mat)
% figure
% mesh(occ_mat)

end

