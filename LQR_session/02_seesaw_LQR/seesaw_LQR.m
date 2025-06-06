%% Balancing Beam Stabilization with LQR Controller and Linear Animation Only
clear; close all; clc;
pkg load symbolic
pkg load control

%% System Parameters
m1    = 0.2;       % mass at one end [kg]
m2    = 0.35;       % mass at the other end [kg]
mb    = 0.5;        % mass of the beam [kg]
L     = 1;          % beam length [m]
g     = 9.81;       % gravitational acceleration [m/s^2]
b     = 0.08;       % viscous damping coefficient [N*m*s/rad]
u_c   = 0.001;      % Coulomb friction coefficient
eps   = 1e-3;       % smoothing parameter for tanh

% Precomputed inertia term
I  = 1/12*mb*L^2 + 1/4*(m1+m2)*L^2;
aa = b/I;
bb = (u_c*g*L)/(2*I);
cc = ((m2-m1)*g*L)/(2*I);
dd = L/(2*I);

%% Operating point for stabilization
theta_e     = -pi/2;
theta_dot_e = 0;
x_e = [theta_e; theta_dot_e];

%% Linearize A and B around operating point
A = [ 0, 1;
-cc*sin(theta_e), -aa - bb/eps];
B = [0; dd];

%% LQR design: tune Q and R
Q = diag([5, 0.1]);
R = 0.1;
[K, S, e_vals] = lqr(A, B, Q, R);
disp('LQR gain K:'); disp(K);
disp('Closed-loop eigenvalues:'); disp(e_vals);

%% Closed-loop dynamics
cl_sys = A - B*K;

%% Simulation settings
tspan = linspace(0, 5, 500)';
x0    = [4*pi/10; -5];          % initial state [rad; rad/s]
x0_err = x0 - x_e;

%% Simulate closed-loop system (error dynamics)
linear_cl = @(t, x_err) cl_sys * x_err;
[t_cl, x_err_sim] = ode45(linear_cl, tspan, x0_err);

% Reconstruct absolute state
x_cl = x_err_sim + x_e';   % [theta; theta_dot]

%% Prepare data for animation
x_total     = x_cl(:,1);
x_total_dot = x_cl(:,2);

% Pre-calculate axis limits
x_lims  = [min(x_total)-0.1, max(x_total)+0.1];
xp_lims = [min(x_total_dot)-0.1, max(x_total_dot)+0.1];

%% Animation Setup
fig = figure;

% 1. x'(t) vs t
subplot(2,2,1);
h1 = plot(tspan(1), x_total_dot(1), 'g', 'LineWidth', 1.5); hold on;
h1_marker = plot(tspan(1), x_total_dot(1), 'mo', 'MarkerFaceColor', 'm');
title("x'(t) vs t"); xlabel('t'); ylabel("x'(t)");
xlim([tspan(1) tspan(end)]);
ylim(xp_lims);
grid on;

% 2. Phase space (vector field linear) with equilibrium indicator and distance arrow
subplot(2,2,2);
hold on;
[theta_grid, omega_grid] = meshgrid(linspace(x_lims(1), x_lims(2), 20), linspace(xp_lims(1), xp_lims(2), 20));

dtheta_l = omega_grid;
domega_l = -cc*sin(theta_e).*(theta_grid - theta_e) - (aa + bb/eps).*(omega_grid - theta_dot_e);

quiver(theta_grid, omega_grid, dtheta_l, domega_l, 'k');
% Trajectory
h2 = plot(x_total(1), x_total_dot(1), 'g', 'LineWidth', 1.5);
h2_marker = plot(x_total(1), x_total_dot(1), 'mo', 'MarkerFaceColor', 'm');
% Equilibrium point marker
h_eq = plot(theta_e, theta_dot_e, 'kp', 'MarkerSize', 10, 'MarkerFaceColor', 'y');
title('Phase Space'); xlabel('x'); ylabel("x'(t)");
xlim(x_lims); ylim(xp_lims); grid on;

% 3. 3D Beam Animation
subplot(2,2,3);
axis_lim = L/2;
axis([-axis_lim axis_lim -axis_lim axis_lim -axis_lim axis_lim]); grid on; hold on;
view([70 30]); title('3D Beam Animation'); xlabel('X'); ylabel('Y'); zlabel('Z');
beam_pts = [-L/2,0,0; L/2,0,0];
plot3(0,0,0,'ko','MarkerFaceColor','k');
h_beam = plot3(nan, nan, nan, 'g-', 'LineWidth', 2);
mass_scale = 50;
h_m1   = plot3(nan, nan, nan, 'mo', 'MarkerSize', m1*mass_scale, 'MarkerFaceColor', 'm');
h_m2   = plot3(nan, nan, nan, 'co', 'MarkerSize', m2*mass_scale, 'MarkerFaceColor', 'c');

% 4. Rotated x(t) vs t
subplot(2,2,4);
h3 = plot(x_total(1), tspan(1), 'g', 'LineWidth', 1.5); hold on;
h3_marker = plot(x_total(1), tspan(1), 'mo', 'MarkerFaceColor', 'm');
title("t vs x(t)"); xlabel("x"); ylabel('t'); xlim(x_lims); ylim([tspan(1) tspan(end)]); grid on;

% Animation parameters
global frame_step pause_time;
frame_step = 5;
num_frames = length(tspan);
pause_time = frame_step/num_frames;
fig_handle = true;

while ishandle(fig)
    for k = 1:frame_step:num_frames
        if ~ishandle(fig)
          fig_handle = false;
        end
        tt   = tspan(k);
        xk   = x_total(k);
        xdk  = x_total_dot(k);

        % Update x'(t) vs t
        set(h1, 'XData', tspan(1:k), 'YData', x_total_dot(1:k));
        set(h1_marker, 'XData', tt, 'YData', xdk);

        % Update phase space
        set(h2, 'XData', x_total(1:k), 'YData', x_total_dot(1:k));
        set(h2_marker, 'XData', xk, 'YData', xdk);

        % Update 3D beam
        beam_rot = (roty(rad2deg(xk)) * beam_pts')';
        set(h_beam, 'XData', beam_rot(:,1), 'YData', beam_rot(:,2), 'ZData', beam_rot(:,3));
        set(h_m1, 'XData', beam_rot(2,1), 'YData', beam_rot(2,2), 'ZData', beam_rot(2,3));
        set(h_m2, 'XData', beam_rot(1,1), 'YData', beam_rot(1,2), 'ZData', beam_rot(1,3));

        % Update rotated plot
        set(h3, 'XData', x_total(1:k), 'YData', tspan(1:k));
        set(h3_marker, 'XData', xk, 'YData', tt);

        % Update title
        subplot(2,2,3);
        title(sprintf('Time=%.2f, θ=%.2f', tt, xk));

        pause(pause_time); drawnow;
    end
    % Break outer loop if figure closed
    if ~fig_handle
        break;
    end
end
