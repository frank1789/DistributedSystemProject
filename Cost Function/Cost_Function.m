function [ V_xy ] = Cost_Function( sub_occ_matr)

%Ipotesi di sottomatrice quadrata
x_0 = 2;%floor(length(sub_occ_matr(1,:))/2);
y_0 = floor(length(sub_occ_matr(1,:))/2);%x_0;

%Inizializzazione
V_xy       = zeros(size(sub_occ_matr))+10000;
%Settare a 0 le posizioni occupate dal robot /caso robot occupa 1 sola
%cella
V_xy(x_0,y_0)  = 0;

%Update Loop

%Primo Quadrante
for i = x_0 : 1 : length(sub_occ_matr(1,:))-1
    for j = y_0 : 1 : length(sub_occ_matr(:,1))-1
[ V_xy ] = Loop_Cost_Funtion( i,j,V_xy,sub_occ_matr );

    end
end

%Secondo Quadrante
for i = x_0 : 1 : length(sub_occ_matr(1,:))-1
    for j = y_0 : -1 : 2

        [ V_xy ] = Loop_Cost_Funtion( i,j,V_xy,sub_occ_matr );
        
     end
end

% %Terzo Quadrante
% for i = x_0 : -1 : 2
%     for j = y_0 : -1 : 2
%         
%         [ V_xy ] = Loop_Cost_Funtion( i,j,V_xy,sub_occ_matr );
%         
%     end
% end
% 
% %Quarto Quadrante
% for i = x_0 : -1 : 2
%     for j = y_0 : 1 : length(sub_occ_matr(1,:))-1
%         
%         [ V_xy ] = Loop_Cost_Funtion( i,j,V_xy,sub_occ_matr );
%         
%     end
% end

figure
surf(V_xy);

end