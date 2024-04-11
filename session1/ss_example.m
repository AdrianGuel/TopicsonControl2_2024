% Define the number of states
n = 5;

% Generate random state-space model
A = randn(n, n);  % State matrix
B = randn(n, 1);   % Input matrix
C = randn(1, n);   % Output matrix
D = randn(1, 1);   % Feedthrough matrix

% Create the state-space model
sys = ss(A, B, C, D);

% Define simulation time
t = 0:0.1:10;  % Time from 0 to 10 seconds with 0.1 second intervals

% Generate step input
u = ones(size(t));  % Step input

% Simulate the state-space model
[y, t, x] = lsim(sys, u, t);

% Plot results
figure;
for i = 1:n
    subplot(n, 1, i);
    plot(t, x(:, i));
    xlabel('Time');
    ylabel(['State ', num2str(i)]);
    title(['State ', num2str(i), ' over Time']);
end
