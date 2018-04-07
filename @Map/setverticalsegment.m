function [vsegment] = setverticalsegment(this, input)
% setverticalsegment connect point and make a horizontal segment.
% The function maps the incoming matrix and extracts the indices, so the
% adjacent ones are searched, saving the indices of the latter.
% @param [in] input = matrix from map generator
% @param [out] vsegment = indicies of point

[row, col] = find(input(:,:));
z = [col.';row.'];
p = find(diff(z(2,:))==1);
q = [p;p+1];
vsegment = q;
clear q p z

end % fuction