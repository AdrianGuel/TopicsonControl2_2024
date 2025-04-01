%Comparison between a LTI vs LTV system with a delayed input and output

% Parameters
h = 0.01;
t = (0:h:10)';
d_time = 1;
delay_samples = round(d_time / h); % Ensure integer for indexing
y0 = 0;

% Input functions
input = @(t) sin(t);
input_d = @(t) (t >= d_time) .* input(t - d_time);

% Define ODEs explicitly
% LTI system: dy/dt = u(t) - y
f_LTI = @(y, t) input(t) - y;
f_LTI_ID = @(y, t) input_d(t) - y;

% LTV system: dy/dt = u(t) - t*y
f_LTV = @(y, t) input(t) - t*y;
f_LTV_ID = @(y, t) input_d(t) - t*y;

% Solve the ODEs using lsode
y_LTI = lsode(f_LTI, y0, t);
y_LTI_ID = lsode(f_LTI_ID, y0, t);

y_LTV = lsode(f_LTV, y0, t);
y_LTV_ID = lsode(f_LTV_ID, y0, t);

% Delayed output
y_LTI_OD = [zeros(delay_samples, 1); y_LTI(1:end-delay_samples)];
y_LTV_OD = [zeros(delay_samples, 1); y_LTV(1:end-delay_samples)];

% Plotting
figure(1, 'name', 'Solution to a LTI System');
plot(t, y_LTI_ID, 'r', t, y_LTI_OD, 'b--');
legend('Delayed u(t)', 'Delayed y(t)');
xlabel('Time (s)'); ylabel('Amplitude');
title('Solution of $\dot{y}(t) + y(t) = u(t)$', 'interpreter', 'latex');
grid on;

figure(2, 'name', 'Solution to a LTV System');
plot(t, y_LTV_ID, 'r', t, y_LTV_OD, 'b');
legend('Delayed u(t)', 'Delayed y(t)');
xlabel('Time (s)'); ylabel('Amplitude');
title('Solution of $\dot{y}(t) + ty(t) = u(t)$', 'interpreter', 'latex');
grid on;
