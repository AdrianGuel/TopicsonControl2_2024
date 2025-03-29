function cart_pendulum_animation()
% Parameters
    g = 9.81;       % Gravity (m/s^2)
    L = 1;          % Length of pendulum (m)
    m = 1;          % Mass of pendulum (kg)
    M = 5;          % Mass of cart (kg)
    b = 0.1;        % Damping coefficient
    tspan = [0 10]; % Time span for simulation

    % Initial conditions
    theta0 = pi;  % Initial angle (radians)
    x0 = 0;         % Initial position of cart (m)
    vtheta0 = 0;    % Initial angular velocity (rad/s)
    vx0 = 0.1;        % Initial velocity of cart (m/s)

    % Define the initial state vector
    initial_state = [x0; vx0; theta0; vtheta0];

    % Solve differential equations
    [t, state] = ode45(@(t, state) cart_pendulum_ode(t, state, g, L, m, M, b), tspan, initial_state);

    % Extract positions
    x = state(:, 1);
    theta = state(:, 3);

    % Plot animation
    figure;
    for i = 1:length(t)
        % Cart position
        cart_x = x(i);
        cart_y = 0;

        % Pendulum position
        pendulum_x = cart_x + L * sin(theta(i));
        pendulum_y = -L * cos(theta(i));

        % Plot cart and pendulum
        plot([cart_x, pendulum_x], [cart_y, pendulum_y], 'k', 'LineWidth', 2);
        hold on;
        plot(cart_x, cart_y, 'ro', 'MarkerSize', 10, 'MarkerFaceColor', 'r');
        plot(pendulum_x, pendulum_y, 'ko', 'MarkerSize', 20, 'MarkerFaceColor', 'b');
        hold off;

        % Set axis limits
        axis([-2 2 -2 2]);
        axis equal;
        title(sprintf('Cart Pendulum Animation (Time: %.2f s)', t(i)));
        xlabel('x (m)');
        ylabel('y (m)');
        drawnow;
        pause(0.05); % Adjust the pause time to control animation speed
    end
end

function dydt = cart_pendulum_ode(t, state, g, L, m, M, b)
    % Unpack state vector
    x = state(1);
    dx = state(2);
    theta = state(3);
    dtheta = state(4);

    % Differential equations
    dxdt = dx;
    ddxdt = (m * L * dtheta^2 * sin(theta) + m * g * cos(theta) * sin(theta) - b * dx) / (M + m * (1 - cos(theta)^2));
    dthetadt = dtheta;
    ddthetadt = (-g * (M + m) * sin(theta) - cos(theta) * ddxdt) / L;

    % Pack the derivatives
    dydt = [dxdt; ddxdt; dthetadt; ddthetadt];
end

% Call the main function
cart_pendulum_animation();
