function tba=tinv(tab)

tba = zeros(size(tab));
for t=1:3:size(tab,1),
   tba(t:t+2) = tinv1(tab(t:t+2));
end
end

