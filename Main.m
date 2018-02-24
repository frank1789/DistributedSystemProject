clear all
clc
close all
%% Set Parametri

occ_dim            = 21;
max_range          = occ_dim;  %max_range rangefinder
grid_size          = 15;       %grid square edge
n                  = 2;        %number of robot
t_rel         = zeros(n,2);    %target vector in local RF
t_glob        = zeros(n,2);    %target vector in global RF
t_glob_nw     = zeros(n,2);
t_rel_nw      = zeros(n,2);

t_rel_2      = zeros(occ_dim*4,n,2);    %target vector in local RF
t_glob_2     = zeros(occ_dim*4,n,2);    %target vector in global RF

Ut         = zeros(n,1);
bound      = zeros(occ_dim*4,n);
            

b          =  1;    %coefficient for the Algoritm 1
V          = zeros(occ_dim,occ_dim,n);
Vt         = zeros(n,1);

temp = zeros(84,5);

global_map = zeros(210)+0.5;

%% Inizializzazione robot

Robot(n).pose = [];
Robot(n).sub_occ_matr = [];
Robot(n).Cost_Function = [];

%for z=1:1:130 

Robot(1) = Robot_Creation( Robot(1),20,20,occ_dim); %occ_matrix aggiornata dal lidar
Robot(2) = Robot_Creation( Robot(2),20,10,occ_dim);
% Robot(3) = Robot_Creation( Robot(3),15+z,190,occ_dim);
% Robot(4) = Robot_Creation( Robot(4),190-z,190,occ_dim);
% Robot(5) = Robot_Creation( Robot(5),150-z,150-z,occ_dim);
% Robot(6) = Robot_Creation( Robot(6),35+z,35,occ_dim); %occ_matrix aggiornata dal lidar
% Robot(7) = Robot_Creation( Robot(7),140-z,45,occ_dim);


%% Calcolo della t_glob per ogni robot

for i = 1:1:n      %n number of robot
    V(:,:,i)     = Cost_Function_2(Robot(i).sub_occ_matr);
    bound(:,i)   = Bound_Return(V(:,:,i));
    [Vt(i),idx]  = min(bound(:,i));
    
    [t_glob(i,:),t_rel(i,:)]  = Global_Target_Position( bound(:,i),Robot(i),i,t_rel(i,:),t_glob(i,:),idx );
end



% 
%% Given Occupacy grid
% image = 'Map_Grid.png';
%[ Occ_Grid ] = OccupacyGrid_from_Image(image);



  for i=1:1:n
    [bound_sort(:,i),index(:,i)] = sort(bound(:,i));
    Ut(i) = 1;
  end
  

c=0;

% %% Utility
% for i=1:1:n
%       temp(:,i) = -10000000;
%     for j=1:1:84
% 
%      [t_glob_2(j,i,:),t_rel_2(j,i,:)]  = Global_Target_Position( bound(:,i),Robot(i),i,t_rel(i,:),t_glob(i,:),index(j,i));
%      P = Utilities_Function(t_glob_2(j,:,:),i,n,max_range);
%      
%       if(temp(j,i) < Ut(i) - P - b*bound(index(j,i),i))
%        t_glob_nw(i,:) = t_glob_2(j,i,:);
%        t_rel_nw(i,:) = t_rel_2(j,i,:);
%        temp(j,i) = Ut(i) - P - b*bound(index(j,i),i);
%        c=j;
%      end
%     end
%     %Ciclo per aggiornare i valori delle Utility degli altri rbt
%     for k =1:1:n
%         if(k~=i)
%               P = Utilities_Function(t_glob_2(c,:,:),k,n,max_range);
%               Ut(k) = Ut(k) - P;
%         end
%     end
%  end
%   
% %  figure
% surf(temp)
% %  
% % figure
%  grid on
%  hold on
%  xlim([0 200])
%  ylim([0 200])
% plot(t_glob(:,1),t_glob(:,2), 'r+',t_glob_nw(:,1),t_glob_nw(:,2),'b*')
% %pause('')
% end