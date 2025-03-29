%% pkg install -forge control % use this line of code before loading the package for the first time ever
%% pkg install -forge signal

pkg load control  % load package
pkg load signal  % tf2ss está aquí

% Define a transfer function: G(s) = 1 / (s^2 + 3s + 2)
num = [1];
den = [1 3 2];

% Convert to state-space (tf2ss)
[A, B, C, D] = tf2ss(num, den);

disp('A ='), disp(A)
disp('B ='), disp(B)
disp('C ='), disp(C)
disp('D ='), disp(D)

% Sampling time
T = 0.1;

% Compute matrix exponential expm(A*T)
Ad = expm(A*T);
disp('Ad = expm(A*T) ='), disp(Ad)

% Discretize the system (c2d with ZOH)
sys_c = ss(A, B, C, D);
sys_d = c2d(sys_c, T, 'zoh');

% Display discrete system
disp('Discrete A ='), disp(sys_d.A)
disp('Discrete B ='), disp(sys_d.B)
disp('Discrete C ='), disp(sys_d.C)
disp('Discrete D ='), disp(sys_d.D)

% Optional: plot step responses
figure;
step(sys_c);
title('Continuous-time Step Response');

figure;
step(sys_d);
title('Discrete-time Step Response');
