function [ V_xy ] = Loop_Cost_Funtion(x_0, y_0, V_xy, sub_occ_matr)
%LOOP_COST_FUNTION Summary of this function goes here
%   Detailed explanation goes here

for x = -1:1:1
    for y = -1:1:1
        Delta = sqrt(x^2 + y^2);
        temp = V_xy(x_0, y_0) + Delta * sub_occ_matr((x_0 + x), (y_0 + y));
        if(temp < V_xy(x_0 + x, y_0 + y))
            V_xy(x_0 + x,y_0 + y) = temp;
        end
    end  
end
end % function

