function tba = tinv1(this, tab)
%TINV1  calculates the inverse of one transformations
%
%@param[in] tab - angle

s = sin(tab(3));
c = cos(tab(3));
tba = [-tab(1)*c - tab(2)*s;
        tab(1)*s - tab(2)*c;
       -tab(3)];
end