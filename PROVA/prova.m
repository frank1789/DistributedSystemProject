clear all
clc
close all

load('data_up.mat')
%load('data_dwn.mat')
%load('data_dx.mat')
%load('data_sx.mat')

theta=-pi/2:0.36*pi/180:pi/2;
ris = 0.015;
r0=4/ris;

y=r0*sin(theta);
x=r0*cos(theta);

x_g=floor(x);
y_g=floor(y);

max_x = max(x_g);
max_y = max(y_g);


pos = a.q(1:17,1:2);
jmp = floor(pos/0.015);

occ = occ_mat(:,:,1:17);

x_2     = jmp(1,1) +1: 1 : jmp(1,1) + max_x;

y_2  = jmp(1,2) - max_y : 1 : jmp(1,2)+ max_y-1;

%%
room_length = 17;
room_width  = 17;

lgth =  floor(room_length/ris);
wdt  =  floor(room_width/ris);

Global_map = zeros(lgth,wdt);

center_x = floor(lgth/2);
center_y = floor(wdt/2);

kk=0;

for ii=1:1:40
   if(mod(ii,2)==0)
       
    if(isempty(a.laserScan_xy{ii}) || all((all(isnan(a.laserScan_xy{ii})))==1))
    else
      kk=kk+1;
     for i = 1:1:266
        for j = 1:1:532
            if(occ_mat(i,j,kk)~=0)
                     A     = [cos(-a.q(ii,3)), -sin(-a.q(ii,3)), a.q(ii,1)/0.015;
                              sin(-a.q(ii,3)),  cos(-a.q(ii,3)), a.q(ii,2)/0.015; 
                                0                 0             1]*[i ;j-267; 1];
                        A=floor(A);
                        if( Global_map(A(2)+33,A(1)+33)==0)
                        Global_map(A(2)+33,A(1)+33)= occ_mat(i,j,kk);
                        else
                        Global_map(A(2)+33,A(1)+33)= (occ_mat(i,j,kk) + Global_map(A(2)+33,A(1)+33))/2;
                        end
            end
        end
     end
    end
   end
end

mesh(Global_map);

% for i=1:1:1
% figure 
% mesh(occ_mat(:,:,i))
% end



% 
% theta_2 = pi/2;
% for i = 1:1:length(x_2)
% for j = 1:1:length(y_2)
% A(:,i,j) = [cos(theta_2) -sin(theta_2); sin(theta_2) cos(theta_2)]*[x_2(i) ;y_2(j)];
% end
% end
% 
% for i = 1:1:length(x_2)
% for j = 1:1:length(y_2)
% if(size(A(:,:,i,j))~=[266 532])
%     
%     size(A(:,:,i,j))
% end
% end
% end
% 
% Global_map(A(:,:,i,j)) = 
% 
% A1 = ones(max_x,2*max_y);
% A2 = ones(max_x,2*max_y);
% 
% B1 = ones(max_x,2*max_y);
% B2 = ones(max_x,2*max_y);
% 
% C1 = ones(max_x,2*max_y);
% C2 = ones(max_x,2*max_y);
% 
% D1 = ones(max_x,2*max_y);
% D2 = ones(max_x,2*max_y);
% 
% Global_map = zeros(2*min(size(A1)),2*max(size(A1)));
% 
% y=7;
% x=3;
% 
% if(y<8) % Mi trovo in A2 ... D2
%  
%     if(x<8)   % Mi trovo in A2 B2
%         if(x<4)   % Mi trovo in A2
%             if(any(any(Global_map))==0)
%              Global_map(1:length(A1(:,1)),1:length(A1(1,:)))= A2;
%             else
%              Global_map(1:length(A1(:,1)),1:length(A1(1,:)))=(Global_map(1:length(A1(:,1)),1:length(A1(1,:)))+A2)/2;
%             end
%         else      % Mi trovo in B2
%              if(any(any(Global_map))==0)
%              Global_map(1:length(A1(:,1)),1:length(A1(1,:)))= B2;
%             else
%              Global_map(1:length(A1(:,1)),1:length(A1(1,:)))=(Global_map(1:length(A1(:,1)),1:length(A1(1,:)))+B2)/2;
%             end
%         end
%         
%     else      % Mi trovo in C2 D2
%         
%         if(x<6)   % Mi trovo in C2
%             if(any(any(Global_map))==0)
%              Global_map(1:length(A1(:,1)),1:length(A1(1,:)))= C2;
%             else
%              Global_map(1:length(A1(:,1)),1:length(A1(1,:)))=(Global_map(1:length(A1(:,1)),1:length(A1(1,:)))+C2)/2;
%             end
%         else      % Mi trovo in D2
%             if(any(any(Global_map))==0)
%              Global_map(1:length(A1(:,1)),1:length(A1(1,:)))= D2;
%             else
%              Global_map(1:length(A1(:,1)),1:length(A1(1,:)))=(Global_map(1:length(A1(:,1)),1:length(A1(1,:)))+D2)/2;
%             end
%         end
%         
%         
%     end
% else    % Mi trovo in A1 ... D1
%     
%     if(x<8)   % Mi trovo in A1 B1
%         if(x<4)   % Mi trovo in A1
%             if(any(any(Global_map))==0)   %check se matrice ? nulla
%              Global_map(1:length(A1(:,1)),1:length(A1(1,:)))= A1;
%             else
%              Global_map(1:length(A1(:,1)),1:length(A1(1,:)))=(Global_map(1:length(A1(:,1)),1:length(A1(1,:)))+A1)/2;
%             end
%         else      % Mi trovo in B1
%              if(any(any(Global_map))==0)  %check se matrice ? nulla
%              Global_map(1:length(A1(:,1)),1:length(A1(1,:)))= B1;
%             else
%              Global_map(1:length(A1(:,1)),1:length(A1(1,:)))=(Global_map(1:length(A1(:,1)),1:length(A1(1,:)))+B1)/2;
%             end
%         end
%     
%     else      % Mi trovo in C1 D1
%         
%         if(x<6)   % Mi trovo in C1
%              if(any(any(Global_map))==0)  %check se matrice ? nulla
%              Global_map(1:length(A1(:,1)),1:length(A1(1,:)))= C1;
%             else
%              Global_map(1:length(A1(:,1)),1:length(A1(1,:)))=(Global_map(1:length(A1(:,1)),1:length(A1(1,:)))+C1)/2;
%             end
%         else      % Mi trovo in D1
%              if(any(any(Global_map))==0)  %check se matrice ? nulla
%              Global_map(1:length(A1(:,1)),1:length(A1(1,:)))= D1;
%             else
%              Global_map(1:length(A1(:,1)),1:length(A1(1,:)))=(Global_map(1:length(A1(:,1)),1:length(A1(1,:)))+D1)/2;
%             end
%         end
%         
%         
%     end
%     
% end
% 
% 
% % 
% % if(a.q(1)>0)
% %    if(a.q(2)>0)
% %        %1 Quad
% %        for i =center_x:1:2*center_x 
% %             for j = center_y:-1:0
% %     
% %             end
% %         end
% %    else
% %        %4 Quad
% %         for i =center_x:1:2*center_x 
% %             for j = center_y:1:2*center_y
% %     
% %             end
% %         end
% %    end
% %    
% % elseif(a.q(2)>0)
% %        %2 Quad
% %         for i =0:1:center_x 
% %             for j = 0:1:center_y
% %     
% %             end
% %         end
% %    else
% %        %3 Quad  
% %         for i =0:1:center_x 
% %             for j = center_y:1:2*center_y
% %     
% %             end
% %         end
% % end

% 
% Global_map = zeros(532,532);
% %mesh(ZZ*occ_mat(:,:,16));
% 
%        
%     ii=54
%     
%    ss=1;
%      for i = 1:1:266
%         for j = 1:1:532
%        %     if(occ_mat(i,j,kk)~=0)
%                      ZZ     = [cos(-pi/2), -sin(-pi/2);
%                                sin(-pi/2),  cos(-pi/2)]*[i;j];
%                         %ZZ=floor(ZZ)+1;
%                         %Global_map(ZZ(1),ZZ(2))= occ_mat(i,j,16);
%                BB(ss,:)=ZZ';
%                ss=ss+1;
%            %   mesh(ZZ*occ_mat(:,:,kk));
%            %   kk=kk+1;
%             end
%         end
