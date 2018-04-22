for i =1:1:326
    for j =1:1:326
     a(1,j+326*(i-1)) = i; 
    end
end

for i =1:1:326
    for j =1:1:326
     a(2,j+326*(i-1)) = j; 
    end
end

for i =1:1:326
    for j =1:1:326
    M(i,j); 
    end
end

for i =1:1:326
    for j =1:1:326
   
     a(2,j+326*(i-1)) = j; 
    end
end