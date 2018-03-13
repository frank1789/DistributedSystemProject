function [ occ_mat] = Occ_Grid( occ_mat,lid_mat,a )
%OCC_GRID Summary of this function goes here


beta     =  90;
R        =   4;
Max_Occ  = 0.8;
ris = 0.015;

%Ipotesi di sottomatrice quadrata
x_0 = 1;%floor(length(sub_occ_matr(1,:))/2);
y_0 = floor(length(occ_mat(1,:))/2);%x_0;

for i=1:1:length(a)
   lid_mat(b(1,i),b(2,i))=1;
end

b=[floor(a(1,:)/ris);267-floor(a(2,:)/ris)]+1;

% for i=1:1:length(b)
%    
%     if(b(2,i)<0)
%         b(2,i) = 800;
%     end
%     
% end

for i=1:1:length(a)
   lid_mat(b(1,i),b(2,i))=1;
end

%Primo Quadrante
for i = x_0 : 1 : length(occ_mat(:,1))
    for j = y_0 : 1 : length(occ_mat(1,:))
        
        alpha = atan((y_0-j)/i);
        r     = sqrt(i^2+(y_0-j)^2);
   
        occ_mat(i,j) =  (((R-r)/(R)+(beta-alpha))/2)*Max_Occ*lid_mat(i,j);
    
    end
end

%Secondo Quadrante
for i = x_0 : 1 : length(occ_mat(:,1))
    for j = y_0 : -1 : 1

        alpha = atan((y_0-j)/i);
        r     = sqrt(i^2+(y_0-j)^2);
   
        occ_mat(i,j) =  (((R-r)/(R)+(beta-alpha))/2)*Max_Occ*lid_mat(i,j);
        
     end
end

% figure
% mesh(lid_mat)
% figure
% mesh(occ_mat)

end

