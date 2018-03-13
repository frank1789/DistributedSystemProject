function out = DiscreteApproxLinearisedMdl(in)

% Input parser
x = in(1);
y = in(2);
theta = in(3);
v = in(4);
omega = in(5);
Dt = in(6);

% Discrete simulation
uk = [v; omega];
qk = [x; y; theta];

Ad = eye(3);
A = [0 0 -sin(qk(3))*uk(1);
     0 0  cos(qk(3))*uk(1);
     0 0         0       ];


B = [cos(qk(3)), 0;
     sin(qk(3)), 0;
      0          1];


Bd = (B + Dt/2*A*B)*Dt;

q_k1 = Ad*qk + Bd*uk;

% Output
out = q_k1;

