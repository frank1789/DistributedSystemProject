clear all
close all
clear class
clc


load('test.mat')
%load('data_up.mat')
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

for ii=1:1:882
   if(mod(ii,2)==0)
       
    if(isempty(a.laserScan_2_xy{ii}) || all((all(isnan(a.laserScan_2_xy{ii})))==1))
    else
      kk=kk+1;
     for i = 1:1:266
        for j = 1:1:532
            if(occ_mat(i,j,kk)~=0)
                     A     = [cos(a.q(ii,3)), -sin(a.q(ii,3)), a.q(ii,1)/0.015; 
                              sin(a.q(ii,3)),  cos(a.q(ii,3)), a.q(ii,2)/0.015;  
                                0                 0             1]*[i ;267-j; 1]; 
                        A=floor(A);
                        CC=[A(2)+33,A(1)+33]; 
                        if( Global_map(wdt-CC(1),CC(2))==0) 
                        Global_map(wdt-CC(1),CC(2))= occ_mat(i,j,kk); 
                        else
                        Global_map(wdt-CC(1),CC(2))= (occ_mat(i,j,kk) + Global_map(wdt-CC(1),CC(2)))/2; 
                        end
            end
        end
     end
    end
   end
end

mesh(Global_map);
