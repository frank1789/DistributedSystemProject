function PlotUnicycle(x,y,theta,x_d,y_d,theta_d,x_d2,y_d2,theta_d2,time)

% Vehicle description
Vehicle.r = .5;
Vehicle.dir = 1;

MaxXY = max(max(x), max(y)) + 4*Vehicle.r;
MinXY = min(min(x), min(y)) - 4*Vehicle.r;

% Initial position
figure(1), clf, hold on;
hr = rectangle('Position', [x(1) - Vehicle.r, y(1) - Vehicle.r, 2*Vehicle.r, 2*Vehicle.r], 'Curvature', [1,1], ...
    'EdgeColor', [1 0 0]);
hl = plot([x(1), x(1)+Vehicle.dir*cos(theta(1))], [y(1), y(1)+Vehicle.dir*sin(theta(1))], 'r');
hr_d = rectangle('Position', [x_d(1) - Vehicle.r, y_d(1) - Vehicle.r, 2*Vehicle.r, 2*Vehicle.r], 'Curvature', [1,1], ...
    'EdgeColor', [0 1 0]);
hl_d = plot([x_d(1), x_d(1)+Vehicle.dir*cos(theta_d(1))], [y_d(1), y_d(1)+Vehicle.dir*sin(theta_d(1))], 'g');
hr_d2 = rectangle('Position', [x_d2(1) - Vehicle.r, y_d2(1) - Vehicle.r, 2*Vehicle.r, 2*Vehicle.r], 'Curvature', [1,1], ...
    'EdgeColor', [0 0 1]);
hl_d2 = plot([x_d2(1), x_d2(1)+Vehicle.dir*cos(theta_d2(1))], [y_d2(1), y_d2(1)+Vehicle.dir*sin(theta_d2(1))], 'b');
axis([MinXY, MaxXY, MinXY, MaxXY]);

ht = [];
ht_d = [];
ht_d2 = [];

for i=2:length(x)

    %% Actual trajectory
    
    delete(hr);
    delete(hl);
    if not(isempty(ht))
        delete(ht);
    end

    % Vehicle plot
    hr = rectangle('Position', [x(i) - Vehicle.r, y(i) - Vehicle.r, 2*Vehicle.r, 2*Vehicle.r], 'Curvature', [1,1], ...
        'EdgeColor', [1 0 0]);
    hl = plot([x(i), x(i)+Vehicle.dir*cos(theta(i))], [y(i), y(i)+Vehicle.dir*sin(theta(i))], 'r');
    axis([MinXY, MaxXY, MinXY, MaxXY]);
    
    % Vehicle trajectory
    ht = plot(x(1:i), y(1:i), 'r');


    %% Discrete approximations
    
    delete(hr_d);
    delete(hl_d);
    if not(isempty(ht_d))
        delete(ht_d);
    end
    delete(hr_d2);
    delete(hl_d2);
    if not(isempty(ht_d2))
        delete(ht_d2);
    end
    
    % Vehicle plot
    hr_d = rectangle('Position', [x_d(i) - Vehicle.r, y_d(i) - Vehicle.r, 2*Vehicle.r, 2*Vehicle.r], 'Curvature', [1,1], ...
        'EdgeColor', [0 1 0]);
    hl_d = plot([x_d(i), x_d(i)+Vehicle.dir*cos(theta_d(i))], [y_d(i), y_d(i)+Vehicle.dir*sin(theta_d(i))], 'g');
    hr_d2 = rectangle('Position', [x_d2(i) - Vehicle.r, y_d2(i) - Vehicle.r, 2*Vehicle.r, 2*Vehicle.r], 'Curvature', [1,1], ...
        'EdgeColor', [0 0 1]);
    hl_d2 = plot([x_d2(i), x_d2(i)+Vehicle.dir*cos(theta_d2(i))], [y_d2(i), y_d2(i)+Vehicle.dir*sin(theta_d2(i))], 'b');
    axis([MinXY, MaxXY, MinXY, MaxXY]);
    
    % Vehicle trajectory
    ht_d = plot(x_d(1:i), y_d(1:i), 'g--');
    ht_d2 = plot(x_d2(1:i), y_d2(1:i), 'b--');

    drawnow;
    
    pause(time(i) - time(i-1));
end