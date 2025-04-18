%% Balancing Beam Simulation (Nonlinear and Linearized Models)
clear; close all; clc;
pkg load symbolic

%% System Parameters
m1    = 0.2;       % mass at one end [kg]
m2    = 0.35;       % mass at the other end [kg]
mb    = 0.5;        % mass of the beam [kg]
L     = 1;          % beam length [m]
g     = 9.81;       % gravitational acceleration [m/s^2]
b     = 0.08;       % viscous damping coefficient [N*m*s/rad]
u_c   = 0.001;      % Coulomb friction coefficient
u     = 0;          % control input (force or torque)
eps   = 1e-2;       % smoothing parameter for tanh

% Precomputed constants
I = 1/12*mb*L^2 + 1/4*(m1+m2)*L^2;
aa = b/I;
bb = (u_c*g*L)/(2*I);
cc = ((m2-m1)*g*L)/(2*I);
dd = L/(2*I);


%% Nonlinear Model (ODE)
nonlinear_ode = @(t, x) [
    x(2);
    -aa*x(2) - bb*tanh(x(2)/eps) - cc*cos(x(1))
];

%% Linearized Model around equilibrium theta_e and \theta_e_dot
theta_e = pi/2;
theta_e_dot = 0;

A = [ 0, 1;
-cc*sin(theta_e), -aa - bb/eps];

B = [0; dd];

linear_ode = @(t, x) A * (x) + B*u;

%% Simulation Time and Initial Conditions
tspan = linspace(0, 20, 1000)';       % simulation time [s]
x0    = [4*pi/10; -4];       % initial state [theta (rad); theta_dot (rad/s)]
x0_lin = x0 - [theta_e; theta_e_dot];

%% Solve ODEs
[t_nl, x_nl]   = ode45(nonlinear_ode, tspan, x0);
[t_lin, x_lin] = ode45(linear_ode, tspan, x0_lin);

%% animated section
%% add the point of linearization
x_lin(:,1) = x_lin(:,1) + theta_e;
x_lin(:,2) = x_lin(:,2) + theta_e_dot;

% Extract solutions
x_nl_total = x_nl(:,1);      % Position
x_nl_total_d = x_nl(:,2);    % Velocity

x_lin_total = x_lin(:,1);    % Linearized Position
x_lin_total_d = x_lin(:,2);  % Linearized Velocity

% Pre-calculate axis limits (including both solutions)
x_lims = [min(min(x_nl_total), min(x_lin_total))-0.1, max(max(x_nl_total), max(x_lin_total))+0.1];
xp_lims = [min(min(x_nl_total_d), min(x_lin_total_d))-0.1, max(max(x_nl_total_d), max(x_lin_total_d))+0.1];

% Setup animation
fig = figure;

% Initialize plots
% x'(t) vs t in position 1
subplot(2,2,1);
h1_nl = plot(tspan(1), x_nl_total_d(1), 'b', 'LineWidth', 1.5);
hold on;
h1_lin = plot(tspan(1), x_lin_total_d(1), 'g', 'LineWidth', 1.5);
h1_marker_nl = plot(tspan(1), x_nl_total_d(1), 'ro', 'MarkerFaceColor', 'r');
h1_marker_lin = plot(tspan(1), x_lin_total_d(1), 'mo', 'MarkerFaceColor', 'm');
title("x'(t) vs t");
xlabel('t'); ylabel("x'(t)");
xlim([tspan(1) tspan(end)]);
ylim(xp_lims);
grid on;

% Phase space
subplot(2,2,2);
hold on;

% Create mesh of points in phase space
[theta_grid, omega_grid] = meshgrid(linspace(x_lims(1), x_lims(2), 20), linspace(xp_lims(1), xp_lims(2), 20));

% Evaluate the non linear vector field at each point
dtheta = omega_grid;
domega = -aa*omega_grid - bb*tanh(omega_grid/eps) - cc*cos(theta_grid);

dtheta_l = omega_grid;
domega_l = -cc*sin(theta_e).*(theta_grid - theta_e) - aa.*(omega_grid - theta_e_dot);

% Draw vector field
q1 = quiver(theta_grid, omega_grid, dtheta_l, domega_l, 'g', 'AutoScale', 'on');
q2 = quiver(theta_grid, omega_grid, dtheta, domega, 'b', 'AutoScale', 'on');

% Make them global so they can be accessed from the callback function
global q1_handle q2_handle current_quiver;
q1_handle = q1;
q2_handle = q2;
current_quiver = 'q1';

% Initially hide q2 and show q1
set(q2, 'Visible', 'off');
set(q1, 'Visible', 'on');

uicontrol('Style', 'popupmenu', ...
          'String', {'Vector campo linealizado (q1)', 'Vector campo no lineal (q2)'}, ...
          'Units', 'normalized', ...  % Usar unidades normalizadas
          'Position', [0.78, 0.92, 0.2, 0.05], ...  % Posición en esquina superior derecha con unidades normalizadas
          'Callback', @toggleQuiver);

% Callback function for the dropdown menu
function toggleQuiver(source, ~)
    val = get(source, 'Value');
    global q1_handle q2_handle current_quiver;

    % Hide both quivers
    set(q1_handle, 'Visible', 'off');
    set(q2_handle, 'Visible', 'off');

    % Show the selected one
    if val == 1
        set(q1_handle, 'Visible', 'on');
        current_quiver = 'q1';
    else
        set(q2_handle, 'Visible', 'on');
        current_quiver = 'q2';
    end
end

h2_nl = plot(x_nl_total(1), x_nl_total_d(1), 'b', 'LineWidth', 1.5);
h2_lin = plot(x_lin_total(1), x_lin_total_d(1), 'g', 'LineWidth', 1.5);
h2_marker_nl = plot(x_nl_total(1), x_nl_total_d(1), 'ro', 'MarkerFaceColor', 'r');
h2_marker_lin = plot(x_lin_total(1), x_lin_total_d(1), 'mo', 'MarkerFaceColor', 'm');

title('Phase Space');
xlabel('x(t)'); ylabel("x'(t)");
xlim(x_lims);
ylim(xp_lims);
grid on;

% Line from x(t) to phase space (initially empty)
h_line_x_to_phase_nl = line([0, 0], [0, 0], 'Color', 'r', 'LineStyle', '--', 'LineWidth', 1.5);
h_line_x_to_phase_lin = line([0, 0], [0, 0], 'Color', 'm', 'LineStyle', '-.', 'LineWidth', 1.5);

% Line from x'(t) to phase space (initially empty)
h_line_xp_to_phase_nl = line([0, 0], [0, 0], 'Color', 'r', 'LineStyle', '--', 'LineWidth', 1.5);
h_line_xp_to_phase_lin = line([0, 0], [0, 0], 'Color', 'm', 'LineStyle', '-.', 'LineWidth', 1.5);

% 3D Beam Animation in subplot 3
subplot(2,2,3);
axis_lim = L * 0.5;
axis([-axis_lim axis_lim -axis_lim axis_lim -axis_lim axis_lim]);
grid on; hold on;
xlabel('X'); ylabel('Y'); zlabel('Z');
title('3D Beam Animation');
set(gca, 'Projection', 'perspective');
view([70 30]);

% Beam endpoints in local frame (from -L/2 to L/2)
beam_nl = [-L/2, 0, 0; L/2, 0, 0];
beam_lin = [-L/2, 0, 0; L/2, 0, 0];

% Load angular position data
theta_nl = x_nl_total;
theta_lin = x_lin_total;

animation_step = 5;  % Match the same step as the other animations
mass_scale = 50;     % Scale factor for marker size (reduced for subplot)

% Initial beam transformation and drawing
theta_a_nl = theta_nl(1);
theta_a_lin = theta_lin(1);

beam_a_nl = (roty(rad2deg(theta_a_nl)) * beam_nl')';
beam_a_lin = (roty(rad2deg(theta_a_lin)) * beam_lin')';

% Fixed pivot point
offset = 0.2;
plot3(0, 0, 0, 'ko', 'MarkerSize', 6, 'MarkerFaceColor', 'k');
plot3(0, offset, 0, 'ko', 'MarkerSize', 6, 'MarkerFaceColor', 'k');

% Draw initial beam and store handle
h_beam_nl = plot3(beam_a_nl(:,1), beam_a_nl(:,2), beam_a_nl(:,3), 'b-', 'LineWidth', 2);
h_beam_lin = plot3(beam_a_lin(:,1), beam_a_lin(:,2)+offset, beam_a_lin(:,3), 'g-', 'LineWidth', 2);

% Create handles for the balls
h1 = plot3(nan, nan, nan, 'o', 'MarkerSize', mass_scale*m2, 'MarkerFaceColor', 'r', 'MarkerEdgeColor', 'k');
h2 = plot3(nan, nan, nan, 'o', 'MarkerSize', mass_scale*m1, 'MarkerFaceColor', 'b', 'MarkerEdgeColor', 'k');
h3 = plot3(nan, nan, nan, 'o', 'MarkerSize', mass_scale*m2, 'MarkerFaceColor', 'm', 'MarkerEdgeColor', 'k');
h4 = plot3(nan, nan, nan, 'o', 'MarkerSize', mass_scale*m1, 'MarkerFaceColor', 'c', 'MarkerEdgeColor', 'k');

% Rotated graph of x(t) vs t in position 4 (x vertical, t horizontal)
subplot(2,2,4);
h3_nl = plot(x_nl_total(1), tspan(1), 'b', 'LineWidth', 1.5);
hold on;
h3_lin = plot(x_lin_total(1), tspan(1), 'g', 'LineWidth', 1.5);
h3_marker_nl = plot(x_nl_total(1), tspan(1), 'ro', 'MarkerFaceColor', 'r');
h3_marker_lin = plot(x_lin_total(1), tspan(1), 'mo', 'MarkerFaceColor', 'm');
title("t vs x(t) (rotated 90° counterclockwise)");
ylabel('t'); xlabel("x(t)");  % Swapped labels
xlim(x_lims);  % Use x(t) limits for the x-axis
ylim([tspan(1) tspan(end)]);  % Use time limits for the y-axis
grid on;

h_dummy_linear = plot(NaN, NaN, 'b-', 'LineWidth', 2, 'Visible', 'off');
h_dummy_nonlinear = plot(NaN, NaN, 'g-', 'LineWidth', 2, 'Visible', 'off');

% Crear un objeto de línea invisible para la leyenda general
h_dummy_linear = plot(NaN, NaN, 'b-', 'LineWidth', 2, 'Visible', 'off');
h_dummy_nonlinear = plot(NaN, NaN, 'g-', 'LineWidth', 2, 'Visible', 'off');
legend_h = legend([h_dummy_linear, h_dummy_nonlinear], {'Non-Linear', 'Linear'}, 'Orientation', 'horizontal');
set(legend_h, 'Units', 'normalized');
set(legend_h, 'Position', [0.4, 0.02, 0.2, 0.05]);  % [x, y, ancho, alto]

% Set animation speed
frame_step = 5;
num_frames = length(tspan);
pause_time = frame_step/num_frames;
fig_handle = true;

% Run animation loop until window is closed
while ishandle(fig)
    for k = 1:frame_step:num_frames
        if ~ishandle(fig)
          fig_handle = false;
        end
        current_t = tspan(k);

        % Nonlinear model current values
        current_x_nl = x_nl_total(k);
        current_xp_nl = x_nl_total_d(k);

        % Linear model current values
        current_x_lin = x_lin_total(k);
        current_xp_lin = x_lin_total_d(k);

        % Update x'(t) vs t plot
        set(h1_nl, 'XData', tspan(1:k), 'YData', x_nl_total_d(1:k));
        set(h1_lin, 'XData', tspan(1:k), 'YData', x_lin_total_d(1:k));
        set(h1_marker_nl, 'XData', current_t, 'YData', current_xp_nl);
        set(h1_marker_lin, 'XData', current_t, 'YData', current_xp_lin);

        % Update phase space plot
        set(h2_nl, 'XData', x_nl_total(1:k), 'YData', x_nl_total_d(1:k));
        set(h2_lin, 'XData', x_lin_total(1:k), 'YData', x_lin_total_d(1:k));
        set(h2_marker_nl, 'XData', current_x_nl, 'YData', current_xp_nl);
        set(h2_marker_lin, 'XData', current_x_lin, 'YData', current_xp_lin);

        % Update 3D animation
        theta_a_nl = theta_nl(k);
        beam_a_nl = (roty(rad2deg(theta_a_nl)) * beam_nl')';

        theta_a_lin = theta_lin(k);
        beam_a_lin = (roty(rad2deg(theta_a_lin)) * beam_lin')';

        % Update beam positions
        set(h_beam_nl, 'XData', beam_a_nl(:,1), 'YData', beam_a_nl(:,2), 'ZData', beam_a_nl(:,3));
        set(h_beam_lin, 'XData', beam_a_lin(:,1), 'YData', beam_a_lin(:,2)+offset, 'ZData', beam_a_lin(:,3));

        % Update ball positions
        set(h1, 'XData', beam_a_nl(1,1), 'YData', beam_a_nl(1,2), 'ZData', beam_a_nl(1,3));
        set(h2, 'XData', beam_a_nl(2,1), 'YData', beam_a_nl(2,2), 'ZData', beam_a_nl(2,3));
        set(h3, 'XData', beam_a_lin(1,1), 'YData', beam_a_lin(1,2)+offset, 'ZData', beam_a_lin(1,3));
        set(h4, 'XData', beam_a_lin(2,1), 'YData', beam_a_lin(2,2)+offset, 'ZData', beam_a_lin(2,3));

        % Update 3D title
        subplot(2,2,3);
        title(sprintf('Time = %.2f s, θ_{NL} = %.2f, θ_{Lin} = %.2f', current_t, theta_a_nl, theta_a_lin));

        % Update rotated x(t) vs t plot
        set(h3_nl, 'XData', x_nl_total(1:k), 'YData', tspan(1:k));
        set(h3_lin, 'XData', x_lin_total(1:k), 'YData', tspan(1:k));
        set(h3_marker_nl, 'XData', current_x_nl, 'YData', current_t);
        set(h3_marker_lin, 'XData', current_x_lin, 'YData', current_t);

        % Update connection lines for nonlinear model
        set(h_line_x_to_phase_nl, 'XData', [current_x_nl, current_x_nl], 'YData', [xp_lims(1), current_xp_nl]);
        set(h_line_xp_to_phase_nl, 'XData', [x_lims(1), current_x_nl], 'YData', [current_xp_nl, current_xp_nl]);

        % Update connection lines for linear model
        set(h_line_x_to_phase_lin, 'XData', [current_x_lin, current_x_lin], 'YData', [xp_lims(1), current_xp_lin]);
        set(h_line_xp_to_phase_lin, 'XData', [x_lims(1), current_x_lin], 'YData', [current_xp_lin, current_xp_lin]);

        % Speed control and rendering
        pause(pause_time);
        drawnow;
    end
        % Break outer loop if figure closed
    if ~fig_handle
        break;
    end
end
