function out = UnicycleKinematicModel(in)

% Input parser
x = in(1);
y = in(2);
theta = in(3);
v = in(4);
omega = in(5);

% Kinematic
g_q = [cos(theta), 0; sin(theta), 0; 0, 1];
q_dot = g_q*[v; omega];

% Output
out = q_dot;
