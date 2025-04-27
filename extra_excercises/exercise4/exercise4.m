%type: pkg load control , to load the control package
% Define numerator and denominator polynomials
num = [1, 3];             % s + 3 (numerator)
den = [1, 5, 6];          % s^2 + 5s + 6 (denominator)

% Create the transfer function system
sys = tf(num, den)

% Step response analysis
figure;
step(sys);
title('Step Response');

% Impulse response
figure;
impulse(sys);
title('Impulse Response');

% Bode plot (frequency response)
figure;
bode(sys);
title('Bode Plot');

% Pole-zero map
figure;
pzmap(sys);
title('Pole-Zero Map');

% Time domain simulation with custom input
t = 0:0.01:10;            % Time vector
u = sin(t);               % Input signal (sine wave)
[y, t] = lsim(sys, u, t); % Simulate response

figure;
plot(t, u, 'b', t, y, 'r');
legend('Input', 'Output');
title('System Response to Sine Input');
