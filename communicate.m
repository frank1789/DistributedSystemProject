function communicate(obj, it)
%COMMUNICATE

MAX = 6; % 6[m] maximum distance of comunication
c = combnk(obj,2); % explore all combination groped in 2 colunm
for n = 1:length(c)
    [dist] = euclideandistance(c{n,1}.q(it,:),c{n,2}.q(it,:));
    if (dist < MAX)
        fprintf("one or more robots are in the communication area\n");
        fprintf("establish link\t robot: %i <---> robot: %i\n",c{n,1}.ID,c{n,2}.ID);
    end % if
end % for
end % function