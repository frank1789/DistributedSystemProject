function [hsegment] = sethorizontalsegment(input)
% sethorizontalsegment connect point and make a horizontal segment.
% The function maps the incoming matrix and extracts the indices, so the
% adjacent ones are searched, saving the indices of the latter.
% @param [in] input = matrix from map generator
% @param [out] hsegment = indicies of point

h = waitbar(0,'Please wait...');
[row, col] = find(input(:,:));
z = [row.'; col.'];
inx = [];
for i = 2:length(z)
    first = z(1:2,i-1);
    for j = 1:length(z)
        if z(1:2,j) - first == [0;1]
            inx(:,end+1) = [i - 1; j];
            break
        end
    end
waitbar((i-1) / length(z))
end

hsegment = inx;
clear z i j
close(h)

end %function