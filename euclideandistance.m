function [dist] = euclideandistance(p1, p2)
%EUCLIDEANDISTANCE The Euclidean distance between points p and q is the
% length of the line segment connecting them In Cartesian coordinates, if
% p = (p1, p2,..., pn) and q = (q1, q2,..., qn) are two points in Euclidean
% n-space, then the distance (d) from p to q, or from q to p is given by 
% the Pythagorean formula.
% dist = sqrt((x1 - x2)^2 + (y1 - y2)^2);
% @param [in] p1 1st point
% @param [in] p2 2nd point
% @param [out] dist the distance between point

%parsing 1st point
x1 = p1(1);
x2 = p1(2);
% parsing 2nd point
y1 = p2(1);
y2 = p2(2);

dist = sqrt((x1 - x2)^2 + (y1 - y2)^2);

end % function