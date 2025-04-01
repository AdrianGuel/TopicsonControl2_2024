%type: pkg load control , to load the control package
% Define state space matrices
A = [-2, 1; 0, -3];    % System matrix
B = [0; 1];            % Input matrix
C = [1, 0];            % Output matrix
D = 0;                 % Feedthrough matrix

% Create the state space model
sys_ss = ss(A, B, C, D);

% Display the system
disp('State Space System:');
sys_ss

% Convert to transfer function (if needed)
sys_tf = tf(sys_ss);
disp('Equivalent Transfer Function:');
sys_tf

% Simulate step response
t = 0:0.01:5;          % Time vector
figure;
step(sys_ss, t);
title('Step Response');

% Simulate impulse response
figure;
impulse(sys_ss, t);
title('Impulse Response');

% Simulate with arbitrary input
t = 0:0.01:10;         % Time vector
u = sin(2*t);          % Sinusoidal input
[y, t, x] = lsim(sys_ss, u, t);  % y: output, x: state variables

% Plot results
figure;
subplot(3,1,1);
plot(t, u);
title('Input Signal');
ylabel('Amplitude');

subplot(3,1,2);
plot(t, x);
title('State Variables');
ylabel('Amplitude');
legend('x1', 'x2');

subplot(3,1,3);
plot(t, y);
title('Output Signal');
xlabel('Time (s)');
ylabel('Amplitude');
