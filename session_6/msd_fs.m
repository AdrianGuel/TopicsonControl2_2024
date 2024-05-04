% Define parameters
m = 1; % Mass (kg)
k = 10; % Spring constant (N/m)
c = 0.5; % Damping coefficient (N*s/m)
t_final = 10; % Final time (s)
dt = 0.01; % Time step size (s)

A=[[0,1];[-k,-c]]/m;
B=[0;1]/m;
% Initial conditions
x0 = 1; % Initial displacement (m)
v0 = 0; % Initial velocity (m/s)

% Initialize arrays to store results
t = 0:dt:t_final; % Time array
x = zeros(size(t)); % Displacement array
v = zeros(size(t)); % Velocity array
u = zeros(size(t));

% Initial conditions
x(1) = x0;
v(1) = v0;
figure;
gains=[[-1,-2];5*[-1,-2];10*[-1,-2];15*[-1,-2]];
for control=1:length(gains(:,1))
    p=gains(control,:);
    k_feedback=place(A,B,p);
    % Euler method
    for i = 2:length(t)
        % Calculate acceleration (from F = ma)
        a = (-k*x(i-1) - c*v(i-1)+u(i-1))/m;

        % Update velocity and displacement using Euler method
        v(i) = v(i-1) + a * dt;
        x(i) = x(i-1) + v(i) * dt;
        u(i) = -k_feedback(1)*x(i)-k_feedback(2)*v(i);
    end

    % Plot results
    subplot(length(gains(:,1)),2,control)
    plot(t, x, 'LineWidth', 2);
    subplot(length(gains(:,1)),2,control+1)
    plot(t,u, 'LineWidth', 2)
    xlabel('Time (s)');
    ylabel('Displacement (m)');
    title('Mass-Spring-Damper System Response (Euler Method)');
    grid on;
end
