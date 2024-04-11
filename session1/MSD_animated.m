% Parameters
m = 1;      % Mass (kg)
k = 10;     % Spring constant (N/m)
c = 0.5;    % Damping coefficient (Ns/m)

% Initial conditions
x0 = 1;     % Initial displacement (m)
v0 = 0;     % Initial velocity (m/s)

% Simulation parameters
dt = 0.01;  % Time step (s)
t_end = 10; % End time (s)

% Number of time steps
num_steps = round(t_end / dt);

% Preallocate arrays
x = zeros(1, num_steps);
v = zeros(1, num_steps);
t = zeros(1, num_steps);

% Initial conditions
x(1) = x0;
v(1) = v0;

% Simulation loop
for i = 2:num_steps
    % Compute acceleration
    a = (-k*x(i-1) - c*v(i-1)) / m;

    % Update velocity and position using Euler method
    v(i) = v(i-1) + a * dt;
    x(i) = x(i-1) + v(i) * dt;

    % Update time
    t(i) = t(i-1) + dt;
end

% Animation
figure;
for i = 1:num_steps
    plot(x(i), 0, 'ro', 'MarkerSize', 10, 'MarkerFaceColor', 'r'); % Mass
    hold on;
    plot([0 x(i)], [0 0], 'k-', 'LineWidth', 2); % Spring
    xlim([-2 2]);
    ylim([-1 1]);
    xlabel('Displacement (m)');
    title('Mass-Spring-Damper System Animation');
    grid on;
    drawnow;
    pause(0.01);
    hold off;
end
