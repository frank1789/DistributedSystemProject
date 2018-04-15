function tba = tinv(this, tab)

tba = zeros(size(tab));
for t=1:3:size(tab,1)
   tba(t:t+2) = this.tinv1(tab(t:t+2));
end
end

