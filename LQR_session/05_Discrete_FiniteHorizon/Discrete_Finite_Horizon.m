%% Balancing Beam Stabilization with Finite-Horizon LQR (Discrete-Time)
clear; close all; clc;
pkg load control;

%% System Parameters (continuous-time)
m1    = 0.2;    % mass at one end [kg]
m2    = 0.35;   % mass at other end [kg]
mb    = 0.5;    % beam mass [kg]
L     = 1;      % beam length [m]
g     = 9.81;   % gravity [m/s^2]
b     = 0.08;   % viscous damping [N*m*s/rad]
u_c   = 0.001; % Coulomb friction coeff
eps   = 1e-3;   % smoothing for tanh

% Inertia
I  = 1/12*mb*L^2 + 1/4*(m1+m2)*L^2;
aa = b/I;
bb = (u_c*g*L)/(2*I);
cc = ((m2-m1)*g*L)/(2*I);
dd = L/(2*I);

%% Equilibrium (operating point)
theta_e     = -pi/2;
theta_dot_e = 0;
x_e = [theta_e; theta_dot_e];

%% Linearized continuous-time model
a = [0, 1;
    -cc*sin(theta_e), -aa - bb/eps];
b = [0; dd];

%% Discretize (ZOH)
Ts = 0.01;       % sampling interval [s]
N  = 500;         % control horizon (# steps)
sysc = ss(a,b,eye(2),zeros(2,1));
sysd = c2d(sysc, Ts, 'zoh');
Ad = sysd.A;  Bd = sysd.B;

%% Finite-Horizon LQR (backward Riccati)
Q = diag([5, 0.1]);  % state weight
R = 0.1;             % input weight

P = zeros(2,2,N+1);
K = zeros(1,2,N);
P(:,:,N+1) = Q;        % terminal cost

for i = N:-1:1
    % Compute time-varying gain
    K(:,:,i) = (R + Bd' * P(:,:,i+1) * Bd) \ (Bd' * P(:,:,i+1) * Ad);
    % Riccati recursion
     P(:,:,i)=(Ad-Bd*K(:,:,i))'*P(:,:,i+1)*(Ad-Bd*K(:,:,i))+Q+K(:,:,i)'*R*K(:,:,i);
    %P(:,:,i) = Ad' * P(:,:,i+1) * Ad + Q - Ad' * P(:,:,i+1) * Bd * K(:,:,i);
end

disp('Finite-horizon gains K(:,:,1:N) computed.');

%% Simulation (discrete-time)
x_err = zeros(2, N+1);
x    = zeros(2, N+1);
x(:,1) = [4*pi/10; -5];     % initial absolute state
x_err(:,1) = x(:,1) - x_e;

u = zeros(1,N);
tspan = (0:N) * Ts;

for k = 1:N
    % control action
    u(k) = -K(:,:,k) * x_err(:,k);
    % state update
    x_err(:,k+1) = Ad * x_err(:,k) + Bd * u(k);
    x(:,k+1)     = x_err(:,k+1) + x_e;
end

% Extract for plotting/animation
theta   = x(1,:);  omega = x(2,:);

%% Animation & Plots
fig = figure('Position',[100,100,800,600]);

% 1) Angular velocity vs time
subplot(2,2,1);
plot(tspan, omega, 'g-', 'LineWidth', 1.5);
hold on; plot(tspan, omega, 'mo','MarkerFaceColor','m');
title('\omega(t) vs t'); xlabel('t [s]'); ylabel('\omega [rad/s]'); grid on;

% 2) Phase plot
subplot(2,2,2);
plot(theta, omega, 'g-', 'LineWidth',1.5);
hold on; plot(theta(1), omega(1),'mo','MarkerFaceColor','m');
plot(theta_e, theta_dot_e,'kp','MarkerSize',10,'MarkerFaceColor','y');
title('Phase Space'); xlabel('\theta [rad]'); ylabel('\omega [rad/s]'); grid on;

% 3) 3D Beam animation (discrete frames)
subplot(2,2,3);
axis_lim = L/2; axis([-axis_lim axis_lim -axis_lim axis_lim -axis_lim axis_lim]);
grid on; view([70 30]); hold on;
title('3D Beam Animation'); xlabel('X'); ylabel('Y'); zlabel('Z');
beam_pts = [-L/2,0,0; L/2,0,0];
h_beam = plot3(nan,nan,nan,'g-','LineWidth',2);
h_m1   = plot3(nan,nan,nan,'mo','MarkerSize',m1*50,'MarkerFaceColor','m');
h_m2   = plot3(nan,nan,nan,'co','MarkerSize',m2*50,'MarkerFaceColor','c');

for k = 1:5:length(tspan)
    beam_rot = (roty(rad2deg(theta(k))) * beam_pts')';
    set(h_beam,'XData',beam_rot(:,1),'YData',beam_rot(:,2),'ZData',beam_rot(:,3));
    set(h_m1,'XData',beam_rot(2,1),'YData',beam_rot(2,2),'ZData',beam_rot(2,3));
    set(h_m2,'XData',beam_rot(1,1),'YData',beam_rot(1,2),'ZData',beam_rot(1,3));
    title(sprintf('t = %.2f s, \theta = %.2f rad',tspan(k),theta(k)));
    drawnow;
    pause(0.02);
end

% 4) Angle vs time
subplot(2,2,4);
plot(theta, tspan, 'g-', 'LineWidth',1.5);
hold on; plot(theta, tspan, 'mo','MarkerFaceColor','m');
title('t vs \theta(t)'); xlabel('\theta [rad]'); ylabel('t [s]'); grid on;

