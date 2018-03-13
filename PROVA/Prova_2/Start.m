clear all;
clc;

%% Simulation set-up

% Sampling time
MdlInit.Ts = 1;

% Length of simulation
MdlInit.T = 11;


%% Vehicle set-up

% Vehicle data
Vehicle.q0 = zeros(3,1);

% Simulation in Simulink of the actual trajectory and the discrete
% trajectories:
% a - Simulation parameters for the actual vehicle
hm = open('UnicycleModel');
set_param('UnicycleModel', 'Solver', 'ode45', 'StopTime', num2str(MdlInit.T), 'MaxStep', num2str(MdlInit.Ts));
set_param('UnicycleModel/Unicycle Actual model/Integrator', 'InitialCondition', ['[', num2str(Vehicle.q0'), ']']);
% b - Simulation parameters for the discretised models
set_param('UnicycleModel/Unicycle Discretised Models/Unit Delay Euler', 'InitialCondition', ['[', num2str(Vehicle.q0'), ']']);
set_param('UnicycleModel/Unicycle Discretised Models/Sampling Time', 'Value', num2str(MdlInit.Ts));
set_param('UnicycleModel/Unicycle Discretised Models/Sampler', 'SampleTime', num2str(MdlInit.Ts));
% c - Simulation parameters for Euler
set_param('UnicycleModel/Unicycle Discretised Models/Unicycle Kinematic Euler', 'SampleTime', num2str(MdlInit.Ts));
% d - Simulation parameters for Linearised
set_param('UnicycleModel/Unicycle Discretised Models/Unicycle Kinematic Linearised', 'SampleTime', num2str(MdlInit.Ts));
% e - Actual simulation
sim('UnicycleModel');

% Time reference data
t = OutputEuler.time';

% Storing actual trajectory positions and interpolation
q(:,1) = interp1(OutputQ.time, OutputQ.signals(1).values, t)';
q(:,2) = interp1(OutputQ.time, OutputQ.signals(2).values, t)';
q(:,3) = interp1(OutputQ.time, OutputQ.signals(3).values, t)';
% Storing Euler data
q_d_Euler(1,:) = OutputEuler.signals(1).values;
q_d_Euler(2,:) = OutputEuler.signals(2).values;
q_d_Euler(3,:) = OutputEuler.signals(3).values;
% Storing Linearised data
q_d_Lin(1,:) = OutputLinearised.signals(1).values;
q_d_Lin(2,:) = OutputLinearised.signals(2).values;
q_d_Lin(3,:) = OutputLinearised.signals(3).values;


%% Plot

% Plot unicycle
PlotUnicycle(q(:,1)', q(:,2)', q(:,3)', q_d_Euler(1,:), q_d_Euler(2,:), q_d_Euler(3,:), q_d_Lin(1,:), q_d_Lin(2,:), q_d_Lin(3,:), t);

figure(2), clf, hold on;
plot(t, q_d_Euler(1,:) - q(:,1)')
plot(t, q_d_Lin(1,:) - q(:,1)', 'r')
xlabel('[s]'); ylabel('e_x');
legend('Euler', 'Linearized', 'Location', 'best');

figure(3), clf, hold on;
plot(t, q_d_Euler(2,:) - q(:,2)')
plot(t, q_d_Lin(2,:) - q(:,2)', 'r')
xlabel('[s]'); ylabel('e_y');
legend('Euler', 'Linearized', 'Location', 'best');

figure(4), clf, hold on;
plot(t, q_d_Euler(3,:) - q(:,3)')
plot(t, q_d_Lin(3,:) - q(:,3)', 'r')
xlabel('[s]'); ylabel('e_{\theta}');
legend('Euler', 'Linearized', 'Location', 'best');


