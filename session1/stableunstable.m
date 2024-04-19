% Define stable system
A_stable = [-1 0; 0 -2];  % Stable system matrix
B_stable = [1; 1];         % Input matrix
C_stable = eye(2);         % Output matrix
D_stable = 0;              % Feedthrough matrix

% Define unstable system
A_unstable = [1 0; 0 -1];  % Unstable system matrix
B_unstable = [1; 1];       % Input matrix
C_unstable = eye(2);       % Output matrix
D_unstable = 0;            % Feedthrough matrix

% Define initial conditions
x0 = [1; 1];  % Initial state

% Define time vector
t = 0:0.1:10;  % Time from 0 to 10 seconds with 0.1 second intervals

% Simulate stable system
[y_stable, t_stable, x_stable] = lsim(ss(A_stable, B_stable, C_stable, D_stable), zeros(size(t)), t, x0);

% Simulate unstable system
[y_unstable, t_unstable, x_unstable] = lsim(ss(A_unstable, B_unstable, C_unstable, D_unstable), zeros(size(t)), t, x0);

% Plot stable system animation
figure;
subplot(1, 2, 1);
for i = 1:length(t_stable)
    plot(x_stable(i, 1), x_stable(i, 2), 'ro', 'MarkerSize', 10, 'MarkerFaceColor', 'r'); % Mass
    xlim([-2 2]);
    ylim([-2 2]);
    xlabel('State 1');
    ylabel('State 2');
    title('Stable System Animation');
    grid on;
    drawnow;
    pause(0.01);
end

% Plot unstable system animation
subplot(1, 2, 2);
for i = 1:length(t_unstable)
    plot(x_unstable(i, 1), x_unstable(i, 2), 'ro', 'MarkerSize', 10, 'MarkerFaceColor', 'r'); % Mass
    xlim([-2 2]);
    ylim([-2 2]);
    xlabel('State 1');
    ylabel('State 2');
    title('Unstable System Animation');
    grid on;
    drawnow;
    pause(0.01);
end

