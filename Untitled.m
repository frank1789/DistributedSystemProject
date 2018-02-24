t = [2 5 10;
     2 5 10];
idx_robot = 2;
max_range = 4;
n = 3;

U  = 0;
idx = 0;

front = floor(rand(2,501)*17);

for i=1:1:length(front(1,:))
t(:,2)=front(:,i);
[ P ] = Utilities_Function( t,idx_robot,n,max_range);

if(U<P)
    U=P;
    idx = i;
end
end