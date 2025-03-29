
% Parameters
h = 0.01;
t = (0:h:10)';
y0 = 0;

% Input functions
u1 = @(t) sin(2*t);
u2 = @(t) sin(0.8*t);

# Linear systems #

% LTI system: dy/dt = u_1(t) - y
f_LTI_1 = @(y, t) u1(t)  - y;
y_LTI_1 = lsode(f_LTI_1, y0, t);

% LTI system: dy/dt = u_2(t) - y
f_LTI_2 = @(y, t) u2(t)  - y;
y_LTI_2 = lsode(f_LTI_2, y0, t);

%sum of outputs
y_LTI_SO = y_LTI_1+y_LTI_2;

% LTI system: dy/dt = u_1(t)+u_2(t) - y
%sum of inputs
f_LTI_SI = @(y, t) u1(t)+u2(t) - y;
y_LTI_SI = lsode(f_LTI_SI, y0, t);

# Non Linear systems #

% Non Linear system: dy/dt = sin(u_1(t)) - exp(4y)
f_nL_1 = @(y, t) sin(u1(t)) - exp(4*y);
y_nL_1 = lsode(f_nL_1, y0, t);

% Non Linear system: dy/dt = sin(u_2(t)) - exp(4y)
f_nL_2 = @(y, t) sin(u2(t)) - exp(4*y);
y_nL_2 = lsode(f_nL_2, y0, t);

%sum of outputs
y_nL_SO = y_nL_1+y_nL_2;

% Non Linear system: dy/dt = sin(u_1(t)+u_2(t)) - exp(4y)
%sum of inputs
f_nL_SI = @(y, t) sin(u1(t)+u2(t))  - exp(4*y);
y_nL_SI = lsode(f_nL_SI, y0, t);

% Plotting
figure(1, 'name', 'Linear system');
plot(t, y_LTI_SO, 'r', t, y_LTI_SI, 'b--');
legend('Sum of outputs','Sum of inputs');
xlabel('Time (s)'); ylabel('Amplitude');
title('Linearity of $\dot{y}(t) + y(t) = u(t)$', 'interpreter', 'latex');
grid on;

figure(2, 'name', 'Non - Linear system');
plot(t, y_nL_SO, 'r', t, y_nL_SI, 'b--');
legend('Sum of outputs','Sum of inputs');
xlabel('Time (s)'); ylabel('Amplitude');
title('Linearity of $\dot{y}(t) + y(t) = u(t)$', 'interpreter', 'latex');
grid on;
