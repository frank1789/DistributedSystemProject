function out = DiscreteApproxEulerMdl(in)

% Input parser
x = in(1);
y = in(2);
theta = in(3);
v = in(4);
omega = in(5);
Dt = in(6);

% Discrete simulation
g_q_k = [cos(theta), 0;
         sin(theta), 0;
         0           1];
     
q_k1 = [x; y; theta] + g_q_k*[v; omega]*Dt;

% Output
out = q_k1;