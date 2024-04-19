function simple_pendulum_phase_diagram()
    % Parameters
    g = 9.81;   % Gravity (m/s^2)
    L = 1;      % Length of pendulum (m)

    % Define angle and angular velocity ranges
    theta_range = linspace(-4*pi, 4*pi, 20);
    omega_range = linspace(-10, 10, 20);

    % Create meshgrid for phase space
    [Theta, Omega] = meshgrid(theta_range, omega_range);

    % Calculate derivatives
    dThetadt = Omega;
    dOmegadt = -(g / L) * sin(Theta);

    % Normalize derivatives for plotting arrows
    mag = sqrt(dThetadt.^2 + dOmegadt.^2);
    dThetadt_norm = dThetadt ./ mag;
    dOmegadt_norm = dOmegadt ./ mag;

    % Plot phase diagram
    quiver(Theta, Omega, dThetadt_norm, dOmegadt_norm, 0.5);
    xlabel('Angle (rad)');
    ylabel('Angular Velocity (rad/s)');
    title('Simple Pendulum Phase Diagram');
    axis tight;
    grid on;
end

% Call the main function
simple_pendulum_phase_diagram();
