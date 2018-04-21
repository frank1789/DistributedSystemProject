addpath('Particle_Filter')
close all
%clc
%load datapff.mat
%load test_pf_offline.mat
[xest_a,xa_st] = PF(robot{1,1},1,map,2000);
[xest_b,xb_st] = PF(robot{1,2},1,map,2000);
[xest_c,xc_st] = PF(robot{1,3},1,map,2000);

figure(90); axis equal;
hold on
plot(robot{1,1}.q(:,1),robot{1,1}.q(:,2),'r')
plot(xa_st(:,1),xa_st(:,2),'b')


figure(91); axis equal;
hold on
plot(robot{1,2}.q(:,1),robot{1,2}.q(:,2),'r')
plot(xb_st(:,1),xb_st(:,2),'b')

figure(92); axis equal;
hold on
plot(robot{1,3}.q(:,1),robot{1,3}.q(:,2),'r')
plot(xc_st(:,1),xc_st(:,2),'b')
